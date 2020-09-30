FROM fedora-base-32-x86_64:20200710

# Wifi tools
RUN dnf install -y linux-firmware

# Dev tools
RUN dnf install -y \
  vim git tmux gcc golang python3

# Container tools
RUN dnf install -y \
  buildah podman skopeo

# Desktop packages
RUN dnf copr enable -y pschyska/alacritty # Terminal copr repo
RUN dnf install -y \
  kernel-modules \
  weston \
  sway \
  dmenu alacritty \
  xdg-utils xdg-user-dirs \
  NetworkManager-tui \
  st \ 
  ncmpcpp \
  powerline-fonts
