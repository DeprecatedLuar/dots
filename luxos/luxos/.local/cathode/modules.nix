{ ... }:
{
  imports = [
    ./system/gaming.nix
    ./hardware/laptop.nix
    ./hardware/intel.nix
    ./desktop/compositors/hyprland.nix
#    ./desktops/xfce.nix
    ./desktop-apps.nix
    ./lux-goodies/modern-unix.nix
    ./desktop/shells/ambxst
    ./users/luar
    ./extras.nix
    ./lux-goodies/dev.nix
    ./nixpkgs.nix    
    ./local/packages.nix
    ./local/preferences.nix
  ];
}
