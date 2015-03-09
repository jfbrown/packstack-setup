# BTRFS

Fore general info, check out https://wiki.archlinux.org/index.php/Btrfs.

Once the drives are all set up (not covered here), just add the following
line to your `/etc/fstab`:

```
/dev/sdb	/data	btrfs	noatime,autodefrag,compress-force=lzo,space_cache	0	0
```

That will mount the btrfs cluster including the /dev/sdb drive at /data, optimized
for maximizing space. To optimize for performance, use the
`noatime,discard,ssd,autodefrag,compress=lzo,space_cache` options.

Just run `mount -a` and you'll be all set up! Now check out nfs.markdown for
info on setting up an NFS share with the BTRFS filesystem.

