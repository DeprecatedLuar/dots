{ pkgs, ... }:

{
  #──[Packages]───────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [

#    libreoffice
    audacity
    mailspring
    thunderbird
    anki
    pcmanfm-qt
    netlogo
    xournalpp
    


    megacmd
    whisper-cpp
    scrcpy
    android-tools
    wf-recorder
    opencode
    ollama

    nwg-wrapper
	quickshell

    # Hardware video acceleration diagnostics
    libva-utils
    v4l-utils

    (wrapOBS {
      plugins = with obs-studio-plugins; [ obs-pipewire-audio-capture ];
    })
  ];

  #──[Keyboard / Input]───────────────────────────────────────────────────────

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-m17n
      fcitx5-gtk
    ];
  };

  environment.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
    LIBVA_DRIVER_NAME = "iHD";  # Intel hardware video acceleration
  };

  #──[Network]────────────────────────────────────────────────────────────────

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 443 8080 25565 1433 ];
  };

  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = [ "--accept-dns=false" ];
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "bb720a5aaec04de3" ];
}
