{ ... }:

{
  #──[NVIDIA — PRIME Offload]────────────────────────────────────────────────
  # iGPU drives the display; the dGPU runs on demand via `nvidia-offload`.   

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;  # Open kernel modules; NVIDIA's recommendation for Turing and newer
  };
}
