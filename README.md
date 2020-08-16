# Dracut module

Mount a local device containing multiple squashfs images. Mount a selected image
as the rootfs with a writable ramdisk in overlay.

## USB boot stick creation

Right now there's a script that will create and format the partitions needed for
boot. Rough partition layout/motivation is shown in the table below. Need a
hybrid MBR to support BIOS and UEFI booting.

| Name | Size | Purpose |
| - | - | - |
| BIOS | 1M | Spacer for Hybrid boot partitions (Is this needed? Probably can remove. |
| ESP | 250M | EFI System Partition. Contains rEFInd install for UEFI booting. Configs point to boot files in syslinux. |
| SYSLINUX | 1G | SYSLINUX Install partition. Labeled as boot partition in hybrid MBR, contains kernels and initrd. 
| IMAGES | 6G | Partition containing squashfs images to mount at boot |
| STATEFUL | Rest of disk | Stateful partition for home mount, containers storage, etc |

Modify the parameters and run the script `build_usb_syslinux.sh` to create these
partitions. Afterwards manually create the Hybrid MBR if desired.

```
$ gdisk /dev/sdc
GPT fdisk (gdisk) version 1.0.5

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

# Enter recovery mode
Command (? for help): r

# Create hybrid MBR
Recovery/transformation command (? for help): h

WARNING! Hybrid MBRs are flaky and dangerous! If you decide not to use one,
just hit the Enter key at the below prompt and your MBR partition table will
be untouched.

# Use the BIOS, ESP, and SYSLINUX martitions
Type from one to three GPT partition numbers, separated by spaces, to be
added to the hybrid MBR, in sequence: 1 2 3
Place EFI GPT (0xEE) partition first in MBR (good for GRUB)? (Y/N): N

Creating entry for GPT partition #1 (MBR partition #1)
Enter an MBR hex code (default EF):
Set the bootable flag? (Y/N): n

Creating entry for GPT partition #2 (MBR partition #2)
Enter an MBR hex code (default EF):
Set the bootable flag? (Y/N): n

# Set syslinux as bootable
Creating entry for GPT partition #3 (MBR partition #3)
Enter an MBR hex code (default 83):
Set the bootable flag? (Y/N): y

# Enter expert mode
Recovery/transformation command (? for help): x

# Regenerate disk hashes
Expert command (? for help): h

# Write to disk
Expert command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/sdc.
The operation has completed successfully.
```

### What's a Hybrid MBR?

New partition table (GPT) supports >4 partitions and a bunch of other neat
features. However, older firmware (mostly BIOS boots) only can read the older
partition table format (MBR). To support >4 partitions and BIOS booting we need
to create a GPT partition table that can also be read as an MBR table.

GPT normally includes a protective MBR table, which is read and marks the entire
disk as a single partition. This is to prevent GPT-unaware systems from
overwriting a valid GPT disk. We can edit this protective MBR to point to the
actual GPT partitions that we need at boot. *Caution: This removes the default
protection on the rest of the GPT disk, so be aware the modified MBR table does
not accurately describe the disk*. However this allows a GPT-unaware system to
access some of the partitions defined in the GPT table.

## Add images to USBs

First, build the image locally by running the scripts in `image_builds`. Once
the image is saved to a container storage, add the image name and tag to
`add_image_usb.sh`, then run the script. This will download the image, mount it
on the host filesystem, mount the USB device, and make a squashfs image on the
USB mount.

## Historical notes
Following arch guide from
[here](https://wiki.archlinux.org/index.php/Multiboot_USB_drive#Preparation).

Grub looks like much more of a pain to maintain and set up for a diskless boot.
Using syslinux for bios boots and gummi/systemd boot for efi

How do multiple bootloaders? I think efi is always read for uefi boot, and boot
flag is read for MBR.

Planned partitions

GPT: 
BIOS, EF02, 1MiB
EFI, EF00/FAT32, 1G (Systemd-boot uefi. kernels?)
KERNELS, (syslinux install, kernels?), bootable flag
IMAGES, (dir to mount)

How to join EFI and BIOS kernels? rEFInd can boot point to a different mount
point, so have an only rEFIind partition that points to syslinux?

Create GPT partitions above
1: +1M, EF02, BIOS
2: +1G, EF00, ESP
3: +1G, 8300, SYSLINUX
4: +6G, 8300, IMAGES 
5: +6G, 8300, STATEFUL
Write to disk

add hybrid MBR
gdisk /dev/sdd
r (recovery mode)
h (hybrid MBR)
1 2 3 (first 3 partitions)
EPI GT first? N
1 Bootable? N
2 Bootable? N
3 Bootable? Y
x (experts)
h (re-write hashes)
w (write disk)

Format partitions
ESP - FAT32
mkfs.fat -F32 /dev/sdd2
SYSLINUX - FAT32
mkfs.fat -F32 /dev/sdd3
IMAGES/STATEFUL - ext4
for i in $(seq 4 5); do mkfs.ext4 /dev/sdd$i ; done
e2label /dev/{} {}

### Syslinux install

```
syslinux /dev/sdd3
mount /dev/sdd3 /mnt
cp syslinux.cfg /mnt/
umount /mnt
fatlabel /dev/sdd3 SYSLINUX
```
Nothing happened until I added mbr boot code to the start of the disk. I guess
this is why the BIOS partition exists, but man this is scary

### Refind install

```
mount /dev/disk/by-partlabel/ESP /mnt
mkdir /mnt/EFI/refind
cp /usr/share/refind/refind_x64.efi /mnt/EFI/refind
mkdir /mnt/EFI/BOOT
cp /usr/share/refind/refind_x64.efi /mnt/EFI/BOOT
# Add drivers
mkdir /mnt/EFI/refind/drivers_x64
cp /usr/share/refind/drivers_x64/* /mnt/EFI/BOOT/drivers_x64/

# Install config
cp refind.conf /mnt/EFI/refind/refind.conf
umount /mnt
```

### Install kernels

```
mount /dev/sdd3
cp ...
umount /dev/sdd3
```

## Building image for aarch64

## Refs

* [Hybrid MBRs, by Rod Smith](https://www.rodsbooks.com/gdisk/hybrid.html)
* [Multiboot USB guide from Arch Wiki](https://wiki.archlinux.org/index.php/Multiboot_USB_drive#Preparation).
