{ ... }:

{
  flake-file.inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
}
