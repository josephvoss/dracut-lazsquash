#!/bin/sh

[ -z "$root" ] && root=$(getarg root=)
dev_name=$(getarg dev_name=)
image_name=$(getarg image_name=)
overlay_size=$(getarg overlay_size=)

if [ "$root" == "lazsquash" ] && \
  ! [ -z "dev_name" ] && \
  ! [ -z "image_name" ]; then

  ## Wait for device and don't reload systemd
  wait_for_dev $dev_name

  rootok=1
fi

# vim: set ts=2 sw=2 tw=0 et :
