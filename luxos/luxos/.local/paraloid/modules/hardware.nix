{ config, pkgs, ... }:

{
  #──[Bootloader]────────────────────────────────────────────────────────────

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  #──[Graphics]──────────────────────────────────────────────────────────────

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

 #──[Drawing Tablets]───────────────────────────────────────────────────────
 services.xserver.wacom.enable = true;
 services.xserver.digimend.enable = true;

 environment.systemPackages = with pkgs; [
   libwacom
   kdePackages.wacomtablet  # You might not need this on Hyprland, but won't hurt
 ];
}
