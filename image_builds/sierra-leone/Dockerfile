FROM centos-zfs-8.2.2004-x86_64:latest

# Vdev
COPY vdev_id.conf /etc/zfs/

# NFS server exports
COPY exports /etc/

# Hostname
RUN echo "sierra-leone" >> /etc/hostname
