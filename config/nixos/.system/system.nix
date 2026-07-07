{ config, pkgs, lib, mainUser, hostName, compositors, ... }:

let
  hasDesktop = compositors != [];
in
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
         # Dead man's switch for rebuilds
          (pkgs.writeShellScriptBin "meltdown" (builtins.readFile ./scripts/lib/meltdown))

         micro
         ncdu
         tailscale
         ranger
         zoxide
         starship
         btop
         gh
                 
         sshfs
        mosh
         ripgrep
         git
         wget
         lsof
         ffmpeg
         fd
         jq
         tmux
         at
         lm_sensors
         pciutils
         zip        
         unzip
         dnsutils
         file
         nmap
         socat
         tcpdump
         entr
         tree
         squashfsTools

         go
         python3
         nodejs
         cargo
         rustc
         gcc
        # claude-code

       ] ++ lib.optionals hasDesktop [
         xdotool
         ydotool
         evtest
         appimage-run
         mpv
       ];

       programs.nix-ld.enable = true;

     #──[Audio & Bluetooth]─────────────────────────────────────────────────────

       security.rtkit.enable = lib.mkIf hasDesktop true;

       services.pulseaudio.enable = lib.mkIf hasDesktop false;

       services.pipewire = lib.mkIf hasDesktop {
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

       hardware.bluetooth = lib.mkIf hasDesktop {
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

       boot.kernelModules = lib.optionals hasDesktop [ "uinput" ];
       hardware.uinput.enable = lib.mkIf hasDesktop true;

     #──[Services]──────────────────────────────────────────────────────────────

       services.upower.enable = lib.mkIf hasDesktop true;
       services.openssh.enable = true;
       services.atd.enable = true;
       services.cron.enable = true;
       virtualisation.docker.enable = true;

       # Firewall configuration
      networking.firewall.allowedUDPPortRanges = [
        { from = 60000; to = 61000; }  # mosh
      ];

      systemd.services = { };

     #──[System]────────────────────────────────────────────────────────────────

       # tmpfs for /tmp - clears on reboot (modern standard)
       boot.tmp = {
         useTmpfs = true;
         tmpfsSize = "50%";  # limit to 50% of RAM
       };

       zramSwap.enable = true; # 50% RAM compressed swap, no disk needed

       system.stateVersion = "25.05";

       nix.settings.experimental-features = [ "nix-command" "flakes" ];

     }
