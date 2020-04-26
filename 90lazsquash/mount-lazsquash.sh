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
  if ! [ "$?" != "0" ]; then
    die "$@"
  fi
}

## Mount parititon

## Wait for device and don't reload systemd
wait_for_dev -n $dev_name

# Check for device
if ! [ -f $dev_name ]; then
  die "Can't find device $dev_name! Exiting"
fi

# Detect fs type
fstype=$(blkid -o value -s TYPE $dev_name)
# Load needed fs type
[ -e /sys/fs/$fstype ] || modprobe $fstype

mkdir -p /run/images
mount -n -t "$fstype" -o ro $livedev /run/images
check_last_return "Unable to mount device $dev_name! Exiting."

## Mount squash

if ! [ -f "/run/images/$image_name" ]; then
  die "Can't find Image $image_name on $dev_name! Exiting"
fi
mount -n -t squash -o ro "/run/images/$image_name" "$NEWROOT"
check_last_return "Unable to mount squashed image $image_name! Exiting."

## Mount overlay
mkdir -p /overlay_tmp
if ! [ -z "$overlay_size" ]; then
  mount_options+="-o size=$overlay_size"
fi
mount -n -t tmpfs "$mount_options" none /overlay_tmp
check_last_return "Unable to mount ramdisk! Exiting."
mkdir /overlay_tmp/upper; mkdir /overlay_tmp/work
mount -n -t overlay overlay \
  -o lowerdir="$NEWROOT",upperdir=/overlay_tmp/upper,workdir=/overlay_tmp/workdir \
  "$NEWROOT"
check_last_return "Unable to mount overlayfs! Exiting."

## Bind mount overlay and image share
mkdir -p "$NEWROOT/run/root_overlay"
mkdir -p "$NEWROOT/run/images/"
mount -t bind /overlay_tmp/upper "$NEWROOT/run/root_overlay"
mount -t bind /run/images "$NEWROOT/run/images"

# vim: set ts=2 sw=2 tw=0 et :
