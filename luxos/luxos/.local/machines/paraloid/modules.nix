{ ... }:
{
  imports = [
    ./system/gaming.nix
    ./hardware/laptop.nix
    ./hardware/nvidia.nix
    ./hardware/intel.nix
    ./hardware/tablet.nix
    ./desktop/compositors/hyprland.nix
    ./desktop-apps.nix
    ./lux-goodies/modern-unix.nix
    ./desktop/shells/ambxst
    ./users/luar
    ./extras.nix
    ./lux-goodies/dev.nix
    ./services/docker.nix
    ./unstable.nix
    ./local/hardware-support
    ./local/fingerprint.nix
    ./local/debug.nix
    ./local/packages.nix
    ./local/preferences.nix
  ];
}
