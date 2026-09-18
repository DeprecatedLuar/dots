{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty
    firefox
    vscode-fhs
    imagemagick
    libnotify
    celluloid
    adwaita-icon-theme
    adw-gtk3
    zathura
    gtk3
    gobject-introspection
    (python3.withPackages (ps: with ps; [ pygobject3 ]))
    playerctl
    xfce.tumbler
    ffmpegthumbnailer

    # Qt theming
    darkly
    papirus-icon-theme
    kdePackages.breeze
    adwaita-qt6

    mpv

    # Wallpaper
    swaybg
    feh
  ];

  # GObject-introspection typelibs are not linked into the system profile by
  # default; PyGObject needs both the link and the path to resolve namespaces.
  environment.pathsToLink = [ "/lib/girepository-1.0" ];
  environment.sessionVariables.GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
}
