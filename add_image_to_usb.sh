#!/bin/bash
#
# Create a squashfs from container image, save to USB device
#

image=jvoss-user:f01055c
image=fedora-desktop-32-x86_64:latest
image=dotfiles:e054b24
image=centos-zfs-8.2.2004-x86_64:latest
image=jvoss-user:af221f5
image=root-user:b72a491
image=fedora-lifeboat-32-x86_64:latest

disk_mount=/dev/disk/by-partlabel/IMAGES
mount_point=$(mktemp -d)
output_image=${image/:/-}

container=$(buildah from $image) &&
mount_path=$(buildah mount $container) &&
mount "${disk_mount}" "${mount_point}" &&

mksquashfs "$mount_path" "$mount_point/$output_image" &&
umount "${mount_point}" && rm -rf "${mount_point}" &&

buildah rm $container
