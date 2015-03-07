```
(neutron) net-create ext-net --router:external True
Created a new network:
+---------------------------+--------------------------------------+
| Field                     | Value                                |
+---------------------------+--------------------------------------+
| admin_state_up            | True                                 |
| id                        | d7cf4ced-1d5c-4c57-a3cd-b022ac25dcee |
| name                      | ext-net                              |
| provider:network_type     | vxlan                                |
| provider:physical_network |                                      |
| provider:segmentation_id  | 10                                   |
| router:external           | True                                 |
| shared                    | False                                |
| status                    | ACTIVE                               |
| subnets                   |                                      |
| tenant_id                 | 101f02fdb8604114bfa299d71c7a2ea7     |
+---------------------------+--------------------------------------+
(neutron) subnet-create ext-net --name ext-subnet --allocation-pool start=192.168.1.200,end=192.168.1.250 --disable-dhcp --gateway 192.168.1.1 192.168.1.0/24
Created a new subnet:
+-------------------+----------------------------------------------------+
| Field             | Value                                              |
+-------------------+----------------------------------------------------+
| allocation_pools  | {"start": "192.168.1.200", "end": "192.168.1.250"} |
| cidr              | 192.168.1.0/24                                     |
| dns_nameservers   |                                                    |
| enable_dhcp       | False                                              |
| gateway_ip        | 192.168.1.1                                        |
| host_routes       |                                                    |
| id                | c163f444-09ad-471d-a83c-a22e86cd1934               |
| ip_version        | 4                                                  |
| ipv6_address_mode |                                                    |
| ipv6_ra_mode      |                                                    |
| name              | ext-subnet                                         |
| network_id        | d7cf4ced-1d5c-4c57-a3cd-b022ac25dcee               |
| tenant_id         | 101f02fdb8604114bfa299d71c7a2ea7                   |
+-------------------+----------------------------------------------------+
(neutron) net-create demo-net
Created a new network:
+---------------------------+--------------------------------------+
| Field                     | Value                                |
+---------------------------+--------------------------------------+
| admin_state_up            | True                                 |
| id                        | fadde85a-3885-46d0-91ad-956301212033 |
| name                      | demo-net                             |
| provider:network_type     | vxlan                                |
| provider:physical_network |                                      |
| provider:segmentation_id  | 11                                   |
| router:external           | False                                |
| shared                    | False                                |
| status                    | ACTIVE                               |
| subnets                   |                                      |
| tenant_id                 | 101f02fdb8604114bfa299d71c7a2ea7     |
+---------------------------+--------------------------------------+
(neutron) subnet-create demo-net --name demo-subnet --gateway 10.0.0.1 10.0.0.0/24
Created a new subnet:
+-------------------+--------------------------------------------+
| Field             | Value                                      |
+-------------------+--------------------------------------------+
| allocation_pools  | {"start": "10.0.0.2", "end": "10.0.0.254"} |
| cidr              | 10.0.0.0/24                                |
| dns_nameservers   |                                            |
| enable_dhcp       | True                                       |
| gateway_ip        | 10.0.0.1                                   |
| host_routes       |                                            |
| id                | fe3324c3-6f60-46c7-909c-ad33aa4ecf0e       |
| ip_version        | 4                                          |
| ipv6_address_mode |                                            |
| ipv6_ra_mode      |                                            |
| name              | demo-subnet                                |
| network_id        | fadde85a-3885-46d0-91ad-956301212033       |
| tenant_id         | 101f02fdb8604114bfa299d71c7a2ea7           |
+-------------------+--------------------------------------------+
(neutron) router-create demo-router
Created a new router:
+-----------------------+--------------------------------------+
| Field                 | Value                                |
+-----------------------+--------------------------------------+
| admin_state_up        | True                                 |
| distributed           | False                                |
| external_gateway_info |                                      |
| ha                    | False                                |
| id                    | 1e5cc7f8-9326-4236-b624-2801997400a0 |
| name                  | demo-router                          |
| routes                |                                      |
| status                | ACTIVE                               |
| tenant_id             | 101f02fdb8604114bfa299d71c7a2ea7     |
+-----------------------+--------------------------------------+
(neutron) router-interface-add demo-router demo-subnet
Added interface 1942999b-509c-43bc-bed4-f45792acf092 to router demo-router.
(neutron) router-gateway-set demo-router ext-net
Set gateway for router demo-router
(neutron) security-group-rule-create --protocol icmp --direction ingress default
Created a new security_group_rule:
+-------------------+--------------------------------------+
| Field             | Value                                |
+-------------------+--------------------------------------+
| direction         | ingress                              |
| ethertype         | IPv4                                 |
| id                | 36384d79-6943-4a02-b1b4-685c35ec3e05 |
| port_range_max    |                                      |
| port_range_min    |                                      |
| protocol          | icmp                                 |
| remote_group_id   |                                      |
| remote_ip_prefix  |                                      |
| security_group_id | 38458a8f-57c5-43bc-bfa8-1e350af4971b |
| tenant_id         | 101f02fdb8604114bfa299d71c7a2ea7     |
+-------------------+--------------------------------------+
(neutron) security-group-rule-create --protocol tcp --port-range-min 22 --port-range-max 22 --direction ingress default
Created a new security_group_rule:
+-------------------+--------------------------------------+
| Field             | Value                                |
+-------------------+--------------------------------------+
| direction         | ingress                              |
| ethertype         | IPv4                                 |
| id                | 950bd306-7943-443d-8a67-a8b1325587d8 |
| port_range_max    | 22                                   |
| port_range_min    | 22                                   |
| protocol          | tcp                                  |
| remote_group_id   |                                      |
| remote_ip_prefix  |                                      |
| security_group_id | 38458a8f-57c5-43bc-bfa8-1e350af4971b |
| tenant_id         | 101f02fdb8604114bfa299d71c7a2ea7     |
+-------------------+--------------------------------------+
```
