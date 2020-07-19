#!/bin/bash

dotfiles_hash=$(find dotfiles-*.tar | sed s/dotfiles-// | sed s/.tar//)
buildah bud -f Dockerfile -t dotfiles:$(git rev-parse --short HEAD) .
