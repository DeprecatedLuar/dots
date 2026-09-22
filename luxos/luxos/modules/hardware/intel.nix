{ pkgs, ... }:

{
  #──[Intel iGPU — Video Acceleration]───────────────────────────────────────

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver  # VAAPI (iHD) for Broadwell and newer
      intel-vaapi-driver  # Older VAAPI driver (fallback)
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
}
