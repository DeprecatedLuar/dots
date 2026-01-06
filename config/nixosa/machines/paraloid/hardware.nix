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
}
