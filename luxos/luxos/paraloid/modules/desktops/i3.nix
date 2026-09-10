{ pkgs, ... }:
{
  imports = [ ../system/x11.nix ];

  services.xserver.windowManager.i3.enable = true;

  environment.systemPackages = with pkgs; [
    i3
    picom
  ];
}
