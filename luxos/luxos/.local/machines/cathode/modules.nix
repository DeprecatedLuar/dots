{ ... }:
{
  imports = [
    ./local/hardware-support
    ./packages/lux-goodies/gaming.nix
    ./hardware/laptop
    ./hardware/intel.nix
    ./desktop/compositors/hyprland.nix
#    ./desktops/xfce.nix
    ./packages/lux-goodies/desktop-apps.nix
    ./packages/lux-goodies/modern-unix.nix
    ./desktop/shells/ambxst
    ./users/luar
    ./extras.nix
    ./packages/lux-goodies/dev.nix
    ./unstable.nix
    ./local/packages.nix
    ./local/preferences.nix
    ./hardware/nvidia.nix
    ./desktop/compositors/cinnamon.nix
    ./local/networking.nix
    ./vimsanity
    ./packages/yappers-of-linux.nix
    ./services/tailscale.nix
  ];
}
