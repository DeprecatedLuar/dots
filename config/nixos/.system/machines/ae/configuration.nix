{ ... }:

let
  mainUser = "user";
  hostName = "ae";
  compositors = [ ];
  users = [ "user" ];
  modules = [ ];  # No GUI modules for headless machine
in
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  imports = [ ../../system.nix ];

  _module.args = { inherit mainUser hostName compositors users modules; };
}
