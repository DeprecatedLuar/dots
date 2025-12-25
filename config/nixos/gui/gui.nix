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
    maim
    imagemagick
    pavucontrol
    thunderbird
    libnotify
    brightnessctl
    blueman
    quickshell
  ]
  # Hyprland-specific packages
  ++ lib.optionals hasHyprland [ hyprsunset grimblast ]
  # Niri-specific packages (add when needed)
  ++ lib.optionals hasNiri [ ]
  # XFCE-specific packages (add when needed)
  ++ lib.optionals hasXfce [ ];

  services.flatpak.enable = true;
  xdg.portal.enable = true;  # Required for Flatpak and desktop integration

  #──[Desktop Environment]───────────────────────────────────────────────────

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
    desktopManager.xfce.enable = hasXfce;
  };

  programs.niri.enable = hasNiri;
  programs.hyprland.enable = hasHyprland;
}
