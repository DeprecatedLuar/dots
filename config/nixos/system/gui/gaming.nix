{ config, pkgs, ... }:

{
  #──[Services]───────────────────────────────────────────────────────

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  #──[Graphics]──────────────────────────────────────────────────────────────

  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Required for 32-bit games and Windows games via Proton
  };

  #──[Gaming Packages]───────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    #lutris
    #heroic

    mangohud
    gamemode
    protonup-qt

    equibop
  ];
}
