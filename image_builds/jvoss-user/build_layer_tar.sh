#!/bin/bash

BASE_IMAGE=fedora-base-32-x86_64:20200710

container=$(buildah from $BASE_IMAGE)
mount_path=$(buildah mount $container)

buildah run $container useradd jvoss

# Use a real password from stdin
buildah run --tty $container passwd jvoss

buildah copy $container ./sudoers-jvoss /etc/sudoers.d/jvoss

buildah run $container bash -c \
  "echo /dev/disk/by-label/STATEFUL /home/jvoss/ ext4 defaults >> /etc/fstab"

# Save layers to tar. Change from merged dir to diff dir
tar -C ${mount_path/merged/diff} -cvf rootfs.tar .

buildah rm $container
