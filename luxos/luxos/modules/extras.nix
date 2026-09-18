{ pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;

  environment.systemPackages = with pkgs; [
    tailscale
    sshfs
  ];
}
