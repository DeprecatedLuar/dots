{ config, pkgs, ... }:

{
  #──[Power Management]──────────────────────────────────────────────────────
  powerManagement.enable = true;
  
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger.turbo = "never";
      battery.turbo = "never";
    };
  };
  services.tlp.enable = false;

  services.logind.settings.Login = { # Lid switch behavior
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  #──[Graphics]──────────────────────────────────────────────────────────────

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;

  prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;

    intelBusId = "PCI:0:2:0";    
    nvidiaBusId = "PCI:0:1:0";   
    };
  };

  # Intel GPU hardware acceleration (video decode/encode)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver  # VAAPI for Tiger Lake
      intel-vaapi-driver  # Older VAAPI driver (fallback)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

 #──[Drawing Tablets]───────────────────────────────────────────────────────
 services.xserver.wacom.enable = true;
 services.xserver.digimend.enable = true;
 
 environment.systemPackages = with pkgs; [
   libwacom
   kdePackages.wacomtablet  # You might not need this on Hyprland, but won't hurt
 ];
}
