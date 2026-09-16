{ pkgs, luxos, ... }:
{
  imports = luxos.modules [ "wayland" ];

  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.unstable.hyprland;
  programs.hyprland.withUWSM = true;

  environment.systemPackages = with pkgs.unstable; [
    hyprsunset
    grimblast
    hypridle
    hyprpicker
    swayimg
    hyprpolkitagent
  ];
}
