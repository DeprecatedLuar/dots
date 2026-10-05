{ luxos, ... }:
{
  imports = luxos.modules [ "wayland" ];

  programs.niri.enable = true;
}
