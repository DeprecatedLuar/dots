{ config, pkgs, ... }:

{
  #──[Power Management]──────────────────────────────────────────────────────

  # Thermal management for Intel CPU (prevents overheating)
  services.thermald.enable = true;

  # auto-cpufreq for intelligent CPU scaling (better than TLP for mixed workloads)
  # services.auto-cpufreq.enable = true;
  # services.auto-cpufreq.settings = {
  #   battery = {
  #     governor = "powersave";
  #     turbo = "auto";
  #   };
  #   charger = {
  #     governor = "performance";
  #     turbo = "auto";
  #   };
  # };

  # Manual power profiles (switch with: powerprofilesctl set performance|balanced|power-saver)
  services.power-profiles-daemon.enable = true;

  # Disable conflicting services
  services.tlp.enable = false;

  # Enable general power management
  powerManagement.enable = true;

  # Lid switch behavior
  services.logind = {
    lidSwitch = "suspend";              # Default: suspend on lid close
    lidSwitchExternalPower = "suspend"; # On AC power (change to "ignore" if preferred)
    lidSwitchDocked = "ignore";         # With external display: do nothing
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
