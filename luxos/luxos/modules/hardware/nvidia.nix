{ ... }:

{
  #──[NVIDIA — PRIME Offload]────────────────────────────────────────────────
  # iGPU drives the display; the dGPU runs on demand via `nvidia-offload`.
  # Bus IDs and offload enablement are defaulted by luxos from detected PCI
  # GPUs (framework/gpu.nix, luxos-hardware-defaults.nix) - only set here if
  # detection can't disambiguate the layout.

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;  # Open kernel modules; NVIDIA's recommendation for Turing and newer
  };
}
