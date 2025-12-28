{ config, pkgs, lib, mainUser, compositors, ... }:

let
  # Helper flags for conditional logic
  hasHyprland = builtins.elem "hyprland" compositors;
  hasNiri = builtins.elem "niri" compositors;
  hasXfce = builtins.elem "xfce" compositors;
in
{
  #──[GUI Packages]──────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    # Compositor-agnostic GUI apps
    kitty
    brave
    firefox
    libreoffice
    vscode-fhs
    rofi
    imagemagick
    pavucontrol
    thunderbird
    libnotify
    brightnessctl
    blueman
    quickshell
    swaybg
    xorg.xinit
    matugen
  ]
  # Hyprland-specific packages
  ++ lib.optionals hasHyprland [
    hyprsunset
    grimblast
    hypridle
    hyprlandPlugins.hyprscrolling
    (builtins.getFlake "github:caelestia-dots/shell").packages.${pkgs.system}.with-cli
  ];

  services.flatpak.enable = true;
  xdg.portal.enable = true;  # Required for Flatpak and desktop integration

  # Enable GTK theme sync with xfsettingsd (like GNOME does)
  environment.sessionVariables.GTK_MODULES = "xfsettingsd-gtk-settings-sync";

  #──[Desktop Environment]───────────────────────────────────────────────────

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
    desktopManager.xfce.enable = hasXfce;
  };

  programs.niri.enable = hasNiri;
  programs.hyprland.enable = hasHyprland;
}
