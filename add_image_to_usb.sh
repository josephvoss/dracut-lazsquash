#! /bin/bash

image=fedora-desktop-32-x86_64:latest
output_path=/mnt/1

container=$(buildah from $image)
mount_path=$(buildah mount $container)

mksquashfs "$mount_path" "$output_path/$image"

#buildah copy $container ./90lazsquash /usr/lib/dracut/modules.d/90lazsquash
#
#buildah run $container dnf install -y kernel dracut-network dracut-live
#kernel=$(buildah run $container  bash -c "rpm -q kernel | cut -d '-' -f 2 | sort -r")
#
#buildah run --mount type=bind,src=/tmp,target=/var/tmp $container dracut --no-hostonly --modules "bash lazsquash network kernel-modules kernel-modules-extra" /initrd-$kernel $kernel
#rsync -avz $mount_path/boot/vmlinuz-${kernel}-* $output_path
