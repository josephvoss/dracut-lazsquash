#!/bin/bash

BIOS_SIZE=1M
ESP_SIZE=250M
SYSLINUX_SIZE=1G
IMAGES_SIZE=6G
#STATEFUL_SIZE=rest
BLOCK_SIZE=512

DISK=/dev/sdc

create_sfdisk_input() {
  cat << EOF
label: gpt
# BIOS boot partition, type EF02. Used for hybrid MBR
name=BIOS, size=$(( $(numfmt --from=iec $BIOS_SIZE) / $BLOCK_SIZE )), type=21686148-6449-6E6F-744E-656564454649,
# EFI partition, type EF00
name=ESP, size=$(( $(numfmt --from=iec $ESP_SIZE) / $BLOCK_SIZE )), type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, bootable
# SYSLINUX partition, type 8300, SYSLINUX install for BIOS, holds kernels and initrds
name=SYSLINUX, size=$(( $(numfmt --from=iec $SYSLINUX_SIZE) / $BLOCK_SIZE )), type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, bootable
# IMAGES partition, type 8300, Holds squashed images, mounted and booted by dracut module
name=IMAGES, size=$(( $(numfmt --from=iec $IMAGES_SIZE) / $BLOCK_SIZE )), type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
# STATEFUL partition, type 8300, Holds whatever else you need
name=STATEFUL, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
EOF
}
  
echo "Will run"
create_sfdisk_input
echo "Sleeping"
sleep 1
create_sfdisk_input | sfdisk $DISK

# Format ESP and SYSLINUX as FAT
mkfs.fat -F32 "${DISK}2"
mkfs.fat -F32 "${DISK}3"
# Format IMAGES and STATEFUL as ext4
mkfs.ext4  "${DISK}4"
mkfs.ext4  "${DISK}5"
