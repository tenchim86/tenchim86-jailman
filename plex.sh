#!/bin/sh

echo '{"pkgs":["plexmediaserver-plexpass","ca_root_nss"]}' > /tmp/pkg.json
iocage create -n "plex" -p /tmp/pkg.json -r 11.3-RELEASE ip4_addr="vnet0|192.168.10.23/24" defaultrouter="192.168.10.1" vnet="on" allow_raw_sockets="1" boot="on"
rm /tmp/pkg.json
iocage exec plex mkdir -p /config
iocage exec plex mkdir -p /mnt/library
iocage fstab -a plex /mnt/tank/apps/plex /config nullfs rw 0 0
iocage fstab -a plex /mnt/tank/Library /mnt/library nullfs ro 0 0
iocage exec plex chown -R plex:plex /config
iocage exec plex sysrc "plexmediaserver_plexpass_enable=YES"
iocage exec plex sysrc plexmediaserver_plexpass_support_path="/config"
iocage exec plex service plexmediaserver_plexpass start