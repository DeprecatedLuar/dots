{ pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;

  environment.systemPackages = with pkgs; [
    go
    python3
    nodejs
    cargo
    rustc
    gcc
    gh
  ];
}
