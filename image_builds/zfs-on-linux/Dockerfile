FROM centos-base-8.2.2004-x86_64:20200816

# ZFS
RUN dnf install -y http://download.zfsonlinux.org/epel/zfs-release.el8_2.noarch.rpm && \
  dnf install -y --enablerepo=zfs-kmod --disablerepo=zfs zfs

# Load ZFS at boot
RUN echo "zfs" >> /etc/modules-load.d/zfs.conf

# Dev tools
RUN dnf install -y \
  vim git tmux gcc golang python3

# Rclone
RUN dnf install -y https://downloads.rclone.org/rclone-current-linux-amd64.rpm

# Hostname
RUN echo "siera-leone" >> /etc/hostname

# Vdev
COPY vdev_id.conf /etc/zfs/
