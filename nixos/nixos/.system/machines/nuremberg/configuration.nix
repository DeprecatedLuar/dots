# Auto-generated from machine.toml - DO NOT EDIT
# Edit machine.toml and run: sudo nixos-rebuild switch

{ ... }:

let
  mainUser = "luar";
  hostName = "nuremberg";
  compositors = [  ];
in
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  imports = [
    ../../system.nix
    ./default.nix
    ../../users/luar.nix
  ];

  networking.hostName = hostName;
  _module.args = { inherit mainUser hostName compositors; };
}
