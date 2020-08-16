#!/bin/bash

git_dir=$(mktemp -d)
git_url=git@github.com:josephvoss/dotfiles.git
git_version=origin/package

git clone "$git_url" "$git_dir"
git_hash=$(git --git-dir "${git_dir}/.git" rev-parse --short "$git_version")
git --git-dir "${git_dir}/.git" archive "${git_hash}" > "dotfiles-${git_hash}.tar"

rm -rf $git_dir
