#!/bin/bash

releasever=32
basearch=x86_64

temp_repo=$(mktemp)
cat > $temp_repo << EOF
[core-image-build]
name=Fedora $releasever - $basearch
#baseurl=http://download.example/pub/fedora/linux/releases/$releasever/Everything/$basearch/os/
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-$releasever&arch=$basearch
enabled=1
metadata_expire=7d
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False
EOF

container=$(buildah from scratch) && \
container_mount=$(buildah mount $container) && \

dnf install -c $temp_repo \
  --disablerepo=* --enablerepo=core-image-build \
  --installroot=$container_mount \
  @core && \

dnf clean all -c $temp_repo \
  --installroot=$container_mount && \

buildah commit $container fedora-base-$releasever-$basearch:$(date +%Y%m%d)
rm $temp_repo
