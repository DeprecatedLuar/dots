{ pkgs, mainUser, ... }:

{
  users.users.luar = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "input" "uinput" ];
    packages = with pkgs; [
      quickshell
      matugen
      pinta
      (wrapOBS {
        plugins = with obs-studio-plugins; [
          obs-pipewire-audio-capture
        ];
      })
      copyq
      libreoffice
      brave     
      dstask
      usql
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfrCrs58DjL/Y2FI+9hS+0dVRglxcMfIb9aiALctrrZ luar"
    ];
  };
}
