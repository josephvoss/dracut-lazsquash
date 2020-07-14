#!/bin/bash

mount /dev/disk/by-label/SYSLINUX /mnt
cp -f ./syslinux.cfg /mnt/syslinux.cfg
umount /mnt

mount /dev/disk/by-label/EFI /mnt
cp -f ./refind.conf /mnt/EFI/BOOT/refind.conf
umount /mnt
