# Auto-generated from machine.toml - DO NOT EDIT
# Edit machine.toml and run: sudo nixos-rebuild switch

{ ... }:

let
  mainUser = "luar";
  hostName = "nuremberg";
in
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "25.05";

  imports = [
    /home/luar/Workspace/dev/luxos/system.nix
    ./default.nix
    /home/luar/.config/luxos/.system/users/luar.nix
    /home/luar/.config/luxos/.system/services/nginx.nix
    /home/luar/.config/luxos/.system/services/caddy.nix
  ];

  networking.hostName = hostName;
  _module.args = { inherit mainUser hostName; };
}
