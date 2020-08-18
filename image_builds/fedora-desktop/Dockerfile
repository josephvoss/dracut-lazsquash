FROM fedora-base-32-x86_64:20200710

# Dev tools
RUN dnf install -y \
  vim git tmux gcc golang python3

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
