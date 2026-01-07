{ config, pkgs, ... }:

{
  #──[Power Management]──────────────────────────────────────────────────────

  services.power-profiles-daemon.enable = true;

  #──[Graphics]──────────────────────────────────────────────────────────────

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;

  prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;

    intelBusId = "PCI:0:2:0";      # Change these to match
    nvidiaBusId = "PCI:0:1:0";     # your numbers from step 1
    };
  };

  #──[Wacom Tablet]──────────────────────────────────────────────────────────

  # X11: Uses xf86-input-wacom driver with GUI configuration
  services.xserver.wacom.enable = true;

  # Wayland: Works via libinput (kernel drivers)
  # Configure monitor mapping in Hyprland config (~/.config/hypr/hyprland.conf)

  environment.systemPackages = with pkgs; [
    libwacom  # Tablet definitions for libinput
    kdePackages.wacomtablet  # GUI for X11/XWayland
  ];
}
