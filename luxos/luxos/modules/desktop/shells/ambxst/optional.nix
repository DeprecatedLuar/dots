{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ddcutil               # external monitor brightness
    # wlsunset              # night light
    # gpu-screen-recorder   # screen recording (also enable the program below)
    # tesseract             # OCR
    # matugen               # wallpaper colors
    # mpvpaper              # video wallpapers
    # ffmpeg                # video wallpaper thumbnails
    # socat                 # video wallpaper tint
    # playerctl             # media keybinds
    # zenity                # file picker
    # pavucontrol           # volume control app
    # blueman               # bluetooth manager app
    # networkmanagerapplet  # network settings app
     gradia                # screenshot editor
    # easyeffects           # audio effects
    # tmux                  # tmux sessions tab
    # adw-gtk3              # GTK theme
  ];
  # programs.gpu-screen-recorder.enable = true;    # screen recording
  # services.power-profiles-daemon.enable = true;  # power profile selector
}
