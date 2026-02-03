{ config, pkgs, lib, mainUser, compositors, ... }:

let
  # Helper flags for conditional logic
  hasHyprland = builtins.elem "hyprland" compositors;
  hasNiri = builtins.elem "niri" compositors;
  hasXfce = builtins.elem "xfce" compositors;
  hasOpenbox = builtins.elem "openbox" compositors;
  hasI3 = builtins.elem "i3" compositors;
in
{
  #──[GUI Packages]──────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    # Compositor-agnostic GUI apps
    kitty
    firefox
    vscode-fhs
    rofi
    feh
    imagemagick
    pavucontrol
    libnotify
    brightnessctl
    blueman
    swaybg
    xorg.xinit
    celluloid
    grimblast
    adwaita-icon-theme
    zathura
    wl-clipboard
    playerctl

    i3
    picom    
  ]
  # Hyprland-specific packages
  ++ lib.optionals hasHyprland [
    hyprsunset
    grimblast
    hypridle
    hyprlandPlugins.hyprscrolling
  ];

  services.flatpak.enable = true;
  xdg.portal.enable = true;  # Required for Flatpak and desktop integration

  # Thunar file manager
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-archive-plugin
    ];
  };
  services.gvfs.enable = true;

  #──[Desktop Environment]───────────────────────────────────────────────────

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;  # Proper startx support with module paths
    desktopManager.xfce.enable = hasXfce;
    windowManager.openbox.enable = hasOpenbox;
    windowManager.i3.enable = hasI3;
  };

  services.libinput.enable = true;  # X11 input driver (keyboard/mouse)

  programs.niri.enable = hasNiri;
  programs.hyprland.enable = hasHyprland;

  #──[Qt Theming]────────────────────────────────────────────────────────────

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "adwaita-dark";
  };
}
