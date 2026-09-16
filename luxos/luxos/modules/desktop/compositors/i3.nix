{ pkgs, luxos, ... }:
{
  imports = luxos.modules [ "x11" ];

  services.xserver.windowManager.i3.enable = true;

  environment.systemPackages = with pkgs; [
    i3
    picom
  ];
}
