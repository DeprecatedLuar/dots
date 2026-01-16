{ pkgs, ... }:

{
  #──[Packages]───────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
  
    thunderbird
    
  ];

  #──[Keyboard / Input]───────────────────────────────────────────────────────

  services.xserver.xkb = {
    layout = "us,br";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  environment.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
  };

  #──[Network]────────────────────────────────────────────────────────────────

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 80 443 8080 25565 1433 ];
  };

  services.tailscale.enable = true;
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "bb720a5aaec04de3" ];
}
