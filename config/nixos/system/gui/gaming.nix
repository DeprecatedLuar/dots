{ config, pkgs, ... }:

{
  #──[Services]───────────────────────────────────────────────────────

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [ icu ];  # Required for .NET games (tModLoader, etc.)
    extraCompatPackages = [ pkgs.proton-ge-bin ];
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
    gamescope

    equibop
  ];
}
