{ pkgs, ... }:

{
 #──[Drawing Tablets]───────────────────────────────────────────────────────
 services.xserver.wacom.enable = true;
 services.xserver.digimend.enable = true;

 environment.systemPackages = with pkgs; [
   libwacom
   kdePackages.wacomtablet  # You might not need this on Hyprland, but won't hurt
 ];
}
