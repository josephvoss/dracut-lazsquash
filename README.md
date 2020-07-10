# Dracut module

Mount a local device containing multiple squashfs images. Mount a selected image
as the rootfs with a writable ramdisk in overlay.

## USB boot stick creation

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

# Syslinux install

```
syslinux /dev/sdd3
mount /dev/sdd3 /mnt
cp syslinux.cfg /mnt/
umount /mnt
fatlabel /dev/sdd3 SYSLINUX
```
Nothing happened until I added mbr boot code to the start of the disk. I guess
this is why the BIOS partition exists, but man this is scary

# Refind install

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

# Install kernels

```
mount /dev/sdd3
cp ...
umount /dev/sdd3
```
