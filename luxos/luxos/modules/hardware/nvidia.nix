{ ... }:

{
  #──[NVIDIA — PRIME Offload]────────────────────────────────────────────────
  # iGPU drives the display; the dGPU runs on demand via `nvidia-offload`.
  # Bus IDs are per machine: set hardware.nvidia.prime.{intel,amdgpu}BusId
  # and nvidiaBusId in the host's hardware.nix (`lspci | grep -iE "vga|3d"`).

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;  # Open kernel modules; NVIDIA's recommendation for Turing and newer

    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}
