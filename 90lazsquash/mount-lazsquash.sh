#!/bin/sh
#
# Mount a squashed image from local parition
# 
# Inputs:
# dev_name: device to mount
# image_name: image to mount
# overlay_size: size of overlayfs to make

## Util functions
check_last_return() {
  if [ "$?" != "0" ]; then
    die "$@"
  fi
}

## Mount parititon

# Check for device

### Detect fs type
fstype=$(blkid -o value -s TYPE $dev_name)
### Load needed fs type
[ -e /sys/fs/$fstype ] || modprobe $fstype

mkdir -p /run/images
mount -n -t "$fstype" -o ro $dev_name /run/images
check_last_return "Unable to mount device $dev_name! Exiting."

## Mount squash
mkdir -p /run/squashfs

### Parse image name spliting on commas
IFS=, image_arr=( $image_name )

### Mount each image
image_mounts=()
for image in ${image_arr[@]}; do
  mkdir -p /run/squashfs/$image
  if ! [ -f "/run/images/$image" ]; then
    die "Can't find Image $image on $dev_name! Exiting"
  fi
  mount -n -t squashfs -o ro "/run/images/$image " /run/squashfs/$image
  check_last_return "Unable to mount squashed image $image! Exiting."
  image_mounts+=( "/run/squashfs/$image" )
done
### Join image names for overlay mount
lower_dirs=$(IFS=":" echo "${image_mounts[*]}")

## Mount overlay
mkdir -p /run/overlay
if ! [ -z "$overlay_size" ]; then
  mount_options+="-o size=$overlay_size"
fi
mount -n -t tmpfs $mount_options none /run/overlay/
check_last_return "Unable to mount ramdisk! Exiting."
mkdir /run/overlay/upper; mkdir /run/overlay/work
mount -n -t overlay \
  -o lowerdir=$lower_dirs,upperdir=/run/overlay/upper,workdir=/run/overlay/work \
  overlay "$NEWROOT"
check_last_return "Unable to mount overlayfs! Exiting."

## Bind mount, squash, overlay and image share
mkdir -p "$NEWROOT/run/squashfs"
mkdir -p "$NEWROOT/run/overlay"
mkdir -p "$NEWROOT/run/images/"
mount --bind /run/squashfs "$NEWROOT/run/squashfs"
mount --bind /run/overlay/upper "$NEWROOT/run/overlay"
mount --bind /run/images "$NEWROOT/run/images"

# vim: set ts=2 sw=2 tw=0 et :
