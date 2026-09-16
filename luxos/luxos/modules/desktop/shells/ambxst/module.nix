{ pkgs, inputs, ... }:
{
  environment.systemPackages = [ (pkgs.unstable.callPackage ./package.nix { inherit inputs; }) ];
  services.upower.enable = true;
}
