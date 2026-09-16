{ ... }:
{
  imports = [
    ./system/gaming.nix
    ./desktop/compositors/hyprland.nix
#    ./desktops/xfce.nix
    ./desktop/greeters/ly.nix
    ./desktop-apps.nix
    ./desktop/shells/ambxst
    ./users/luar
  ];
}
