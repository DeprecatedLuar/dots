{ config, pkgs, mainUser, ... }:

{
  #──[GUI Packages]──────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    kitty
    brave
    firefox
    libreoffice
    vscode-fhs
    rofi-wayland
    maim
    imagemagick
    pavucontrol
    thunderbird
    libnotify
    brightnessctl
    hyprsunset
    grimblast
  ];

  services.flatpak.enable = true;

  #──[Desktop Environment]───────────────────────────────────────────────────

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
    desktopManager.xfce.enable = true;
  };

  programs.niri.enable = true;
  programs.hyprland.enable = true;
}
