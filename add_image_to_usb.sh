#!/bin/bash

image=fedora-desktop-32-x86_64:latest
image=jvoss-user:f01055c

output_path=/mnt/1
output_image=${image/:/-}

container=$(buildah from $image)
mount_path=$(buildah mount $container)

mksquashfs "$mount_path" "$output_path/$output_image"

buildah rm $container
