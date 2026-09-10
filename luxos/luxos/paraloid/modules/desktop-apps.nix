{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty
    firefox
    vscode-fhs
    imagemagick
    pavucontrol
    libnotify
    brightnessctl
    blueman
    celluloid
    adwaita-icon-theme
    adw-gtk3
    zathura
    # Multi-MIME clipboard client deps: wl-copy can only advertise a single
    # MIME type per offer, so file copies need a GTK client that advertises
    # text/uri-list and x-special/gnome-copied-files together (like PCManFM).
    gtk3
    gobject-introspection
    (python3.withPackages (ps: with ps; [ pygobject3 ]))
    playerctl
    xfce.tumbler
    ffmpegthumbnailer

    # Qt theming - active theme managed via dotfiles (~/.config/qt6ct/)
    qt6Packages.qt6ct
    darkly
    papirus-icon-theme
    kdePackages.breeze
    adwaita-qt6

    ydotool
    evtest
    mpv
  ];

  # GObject-introspection typelibs are not linked into the system profile by
  # default; PyGObject needs both the link and the path to resolve namespaces.
  environment.pathsToLink = [ "/lib/girepository-1.0" ];
  environment.sessionVariables.GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
}
