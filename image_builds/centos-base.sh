#!/bin/bash

releasever=8.2.2004
basearch=x86_64

temp_repo=$(mktemp)
cat > $temp_repo << EOF
[core-image-build]
name=Centos $releasever - $basearch
baseurl=http://download.example/pub/fedora/linux/releases/$releasever/Everything/$basearch/os/
baseurl=http://mirror.centos.org/centos/$releasever/BaseOS/$basearch/os/
enabled=1
metadata_expire=7d
repo_gpgcheck=0
type=rpm
gpgcheck=0
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

buildah commit $container centos-base-$releasever-$basearch:$(date +%Y%m%d)
rm $temp_repo
