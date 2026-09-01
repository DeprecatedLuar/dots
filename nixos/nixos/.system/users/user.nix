{ pkgs, mainUser, ... }:

{
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      # User-specific packages can go here
      # Most tools are in system.nix already
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfrCrs58DjL/Y2FI+9hS+0dVRglxcMfIb9aiALctrrZ luar"
    ];
  };
}
