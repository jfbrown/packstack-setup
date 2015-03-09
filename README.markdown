# Credits

This is all based on an aggregation of various sources, but primarily from the
following:
  * Shane Cunningham (https://cunninghamshane.com/openstack-juno-all-in-one/)
  * http://docs.openstack.org/juno/install-guide/install/yum/content/neutron_initial-networks-verify.html

# Disclaimer

I'm a web developer, who happens to enjoy this sort of thing. As such, if you too
are not a professional network tech you might find this very useful. However,
I make no claims regarding the accuracy or reliability of the following info.

It worked for me; YMMV.

# Summary

These are rough notes taken while wrestling openstack, via packstack, onto a
server in my basement. I'm starting with a server running a CentOS 7 minimal
install, with 2 NICs. Both have static IPs; 192.168.1.90 on eno1 and
192.168.1.91 on enp3s0. They're both connected to subnet 192.168.1.0/24.

# Preparation & Installation

Install some basic tools to make life better while working. Use whatever you
want, but I think the net-tools package (which provides `route` and `netstat`
is a must.

```
[stack@juno-allinone ~]$ sudo yum install -y vim net-tools
```

Later, when you stop NetworkManager, if you're running static IPs on your
interfaces, when you start up `network`, you'll lose your default
gateway. To avoid
that, set it in `/etc/sysconfig/network`.

```
sudo vim /etc/sysconfig/network

GATEWAY="192.168.1.1"
```

You need to stop NetworkManager, so it doesn't interfere with packstack.

```
[root@juno-allinone ~]# systemctl disable NetworkManager
[root@juno-allinone ~]# systemctl stop NetworkManager
```

Update the system, add the repo, install packstack, and install openstack via
packstack for an all-in-one system.
```

You should also set the `DEVICE` property in the
`/etc/sysconfig/network-scripts/ifcfg-*` files, setting it to the correct name
for each adapter (in my case, `eno1`, `enp3s0`). Once you've done that, take
down all adapters over which you're not connected, and then start the network
daemon.

```
[stack@kermit ~]$ sudo vim /etc/sysconfig/network-scripts/ifcfg-eno1
[stack@kermit ~]$ sudo vim /etc/sysconfig/network-scripts/ifcfg-enp3s0
[root@juno-allinone ~]# ifdown enp3s0
[root@juno-allinone ~]# ifdown eno1 && systemctl start network
[root@juno-allinone ~]# yum update -y
[root@juno-allinone ~]# yum install -y https://rdo.fedorapeople.org/rdo-release.rpm
[root@juno-allinone ~]# yum install -y openstack-packstack
[root@juno-allinone ~]# packstack --allinone --provision-all-in-one-ovs-bridge=n
```

You've then got to set up your interface mapping. Here, it doesn't really matter
whether you use the same, or a different interface as the one you're logged in
from. You just need some interface
to connect to `br-ex`. I'm using my `enp3s0` interface, to leave the `eno1` as
the default admin interface to the physical server.

Here's `eno1`, just for sanity:

```
vim /etc/sysconfig/network-scripts/ifcfg-eno1

DEVICE="eno1"
TYPE="Ethernet"
BOOTPROTO="static"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="yes"
IPV6INIT="no"
NAME="System eno1"
UUID="5367bb9d-02b8-4dcf-975b-e8c832f1d047"
ONBOOT="yes"
IPADDR0="192.168.1.90"
PREFIX0="24"
GATEWAY0="192.168.1.1"
DNS1="192.168.1.1"
DOMAIN="brown-schauer.com"
HWADDR="44:39:C4:3A:85:08"
NM_CONTROLLED="no"
```

And `br-ex`, which takes the properties from enp3s0:

```
vim /etc/sysconfig/network-scripts/ifcfg-br-ex

DEVICE=br-ex
DEVICETYPE=ovs
TYPE=OVSBridge
BOOTPROTO=static
IPADDR=192.168.1.91
NETMASK=255.255.255.0
DNS1=192.168.1.1
ONBOOT=yes
```

And finally `enp3s0`, which delegates its properties to br-ex:

```
vim /etc/sysconfig/network-scripts/ifcfg-enp3s0

DEVICE="enp3s0"
TYPE="OVSPort"
DEVICETYPE="ovs"
OVS_BRIDGE="br-ex"
ONBOOT="yes"
IPV6INIT="no"
NM_CONTROLLED="no"
```

Add the following to the `/etc/neutron/plugin.ini` file. I'm not sure why/if this
is actually necessary, but Shane says to do it, and my setup works, so... The
section you're editing is under the `[ml2_type_vlan]` heading.

```
vim /etc/neutron/plugin.ini

network_vlan_ranges = physnet1
bridge_mappings = physnet1:br-ex
```

Restart networking, to make sure everything's okay. You shouldn't get booted,
if everything was set up correctly.

```
[root@juno-allinone ~]# service network restart
```

Finally, for some reason the packstack installation defaults to `kvm`
virtualization, but we want to run `qemu`. Edit `/etc/nova/nova.conf` to
make the change, and the restart nova.

```
vim /etc/nova/nova.conf

[libvirt]
...
virt_type=qemu
```

```
su

Now go following the instructions in `neutron.readme` to set up the open vswitch
networking components.

PAUSE, while you do that...

And, finally, create some fun ingress rules in the default security group so that
we can actually contact new instances.

```
[stack@juno-allinone ~(keystone_admin)]$ neutron security-group-rule-create \
  --protocol icmp --direction ingress default
[root@juno-allinone ~(keystone_admin)]# neutron security-group-rule-create \
  --protocol tcp --port-range-min 22 --port-range-max 22 --direction ingress default
```

You should now be able to resume the official guides at
https://openstack.redhat.com/Quickstart.
You can add Ubuntu to openstack by following the same technique as with Fedora,
but use the images found here:
https://cloud-images.ubuntu.com/.
You're looking for the `*-disk1.img` files. I've found them irritatingly
slow to boot, but they seem to be okay once they come up.

