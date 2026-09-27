{ pkgs, luxos, ... }:

{
  imports = luxos.modules [ "unstable" ];

  environment.systemPackages = [ pkgs.unstable.noctalia ];
}
