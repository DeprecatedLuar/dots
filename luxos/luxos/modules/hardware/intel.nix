{ inputs, ... }:

{
  flake-file.inputs.nixos-hardware = {
    url = "github:NixOS/nixos-hardware";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  #──[Intel iGPU — Video Acceleration]───────────────────────────────────────
  # nixos-hardware's baseline: VA-API, media runtime, compute runtime, 32-bit
  # drivers, i915 in initrd. Gen8–11 computers set
  # hardware.intelgpu.computeRuntime = "legacy" in their hardware.nix.

  imports = [ inputs.nixos-hardware.nixosModules.common-gpu-intel ];

  hardware.graphics.enable = true;

  # iHD only (Broadwell and newer); also keeps out the unfree intel-ocl that
  # the legacy i965 driver pulls in.
  hardware.intelgpu.vaapiDriver = "intel-media-driver";
}
