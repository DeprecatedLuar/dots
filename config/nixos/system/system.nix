{ config, pkgs, lib, mainUser, hostName, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix  # Auto-generated filesystems
    ./service-loader.nix                   # Dynamic service imports
  ];

     #──[Packages]──────────────────────────────────────────────────────────────

       nixpkgs.config.allowUnfree = true;

       environment.systemPackages = with pkgs; [
         # Self-healing nixos-rebuild wrapper
          (pkgs.writeShellScriptBin "nixos-rebuild" (builtins.readFile ./scripts/nixos-rebuild.sh))

         micro
         git
         wget
         lsof
         fd
         ffmpeg
         xdotool
         ydotool
         tailscale
         ranger
         zoxide
         starship
         docker
         jq
         tmux
         at
         btop
         lm_sensors
         pciutils
         evtest
         gh
         zip
         devbox
         mpv
         unzip

         go
         python3
         nodejs
         cargo
         rustc
         gcc
         claude-code

         appimage-run

       ];
       programs.nix-ld.enable = true;

     #──[Audio & Bluetooth]─────────────────────────────────────────────────────

       services.pulseaudio.enable = false;
       security.rtkit.enable = true;

       services.pipewire = {
         enable = true;
         alsa.enable = true;
         alsa.support32Bit = true;
         pulse.enable = true;
         wireplumber.extraConfig.bluetoothEnhancements = {
           "monitor.bluez.properties" = {
             "bluez5.enable-sbc-xq" = true;
             "bluez5.enable-msbc" = true;
             "bluez5.enable-hw-volume" = true;
             "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
           };
         };
       };

       hardware.bluetooth = {
         enable = true;
         powerOnBoot = true;
         settings.General.Experimental = true;
       };

     #──[Users]─────────────────────────────────────────────────────────────────

       users.users.root.openssh.authorizedKeys.keys = [
         "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfrCrs58DjL/Y2FI+9hS+0dVRglxcMfIb9aiALctrrZ luar"
       ];
       services.openssh.settings.PermitRootLogin = "prohibit-password";
       services.getty.autologinUser = mainUser;

     #──[Input Devices]─────────────────────────────────────────────────────────

       boot.kernelModules = [ "uinput" ];
       hardware.uinput.enable = true;

     #──[Services]──────────────────────────────────────────────────────────────

       services.upower.enable = true;
       services.openssh.enable = true;
       services.atd.enable = true;
       virtualisation.docker.enable = true;

       systemd.services = { };

     #──[Bootloader]────────────────────────────────────────────────────────────

       boot.loader.grub = {
         enable = true;
         efiSupport = true;
         device = "nodev";
         useOSProber = true;
       };
       boot.loader.efi.canTouchEfiVariables = true;


     #──[System]────────────────────────────────────────────────────────────────

       system.stateVersion = "25.05";

       nix.settings.experimental-features = [ "nix-command" "flakes" ];

      }
