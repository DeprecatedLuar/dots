{ pkgs, frameworkModules, ... }:
{
  imports = [ (frameworkModules + "/wayland.nix") ];

  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.unstable.hyprland;

  environment.systemPackages = with pkgs.unstable; [
    hyprsunset
    grimblast
    hypridle
    hyprpicker
    swayimg
  ];
}
