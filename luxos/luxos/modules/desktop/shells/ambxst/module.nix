{ pkgs, inputs, ... }:
let
  upkgs = pkgs.unstable;
  ttf-phosphor-icons = import "${inputs.ambxst}/nix/packages/phosphor-icons.nix" { pkgs = upkgs; };
  patch = import ./patch.nix { pkgs = upkgs; };
in
{
  environment.systemPackages = [ (patch (upkgs.callPackage ./package.nix { inherit inputs; })) ];
  fonts.packages = import "${inputs.ambxst}/nix/packages/fonts.nix" { pkgs = upkgs; inherit ttf-phosphor-icons; };
  services.upower.enable = true;
}
