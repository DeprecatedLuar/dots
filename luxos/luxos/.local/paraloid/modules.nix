{ ... }:
{
  imports = [
    ./system/gaming.nix
    ./desktop/compositors/hyprland.nix
#    ./desktops/xfce.nix
    ./desktop/greeters/ly.nix
    ./desktop-apps.nix
    ./lux-goodies/modern-unix.nix
    ./desktop/shells/ambxst
    ./users/luar
    ./extras.nix
    ./lux-goodies/dev.nix
    ./services/docker.nix
    ./nixpkgs.nix
    ./local/fingerprint.nix
    ./local/hardware.nix
    ./local/packages.nix
    ./local/preferences.nix
  ];
}
