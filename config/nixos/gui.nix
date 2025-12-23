{ config, pkgs, mainUser, ... }:

{
  #──[GUI Packages]──────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    kitty
    brave
    firefox
    heroic
    libreoffice
    vscode-fhs
    equibop
    rofi-wayland
    maim
    imagemagick
    pavucontrol
    thunderbird
    mangohud
    libnotify
    brightnessctl
    gamemode
    hyprsunset
  ];

  programs.steam.enable = true;
  programs.gamemode.enable = true;

  #──[Desktop Environment]───────────────────────────────────────────────────

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
    desktopManager.xfce.enable = true;
  };

  programs.niri.enable = true;
  programs.hyprland.enable = true;
}
