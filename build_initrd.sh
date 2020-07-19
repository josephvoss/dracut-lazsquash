#!/bin/bash

image=fedora-base-32-x86_64:20200710
output_path=/mnt/2

container=$(buildah from $image)
mount_path=$(buildah mount $container)

buildah copy $container ./90lazsquash /usr/lib/dracut/modules.d/90lazsquash

buildah run $container dnf install -y kernel dracut-network dracut-live
kernel=$(buildah run $container  bash -c "rpm -q kernel | sed s/kernel-// | sort -r")

buildah run --mount type=bind,src=/tmp,target=/var/tmp $container \
  dracut --no-hostonly \
  --modules "bash lazsquash network kernel-modules kernel-modules-extra" \
  /boot/initrd-$kernel-lazsquash $kernel
rsync -avz $mount_path/boot/vmlinuz-${kernel} $output_path
rsync -avz $mount_path/boot/initrd-${kernel}-lazsquash $output_path
chmod a+w $output_path/initrd-${kernel}-lazsquash
