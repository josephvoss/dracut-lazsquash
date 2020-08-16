#!/bin/bash

export dotfiles_hash=$(find dotfiles-*.tar | sed s/dotfiles-// | sed s/.tar//)
buildah bud -f Dockerfile -t "dotfiles:${dotfiles_hash}"
