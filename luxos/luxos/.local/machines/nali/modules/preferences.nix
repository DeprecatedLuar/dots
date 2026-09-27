{ ... }:

{
  services.pipewire.jack.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal.config = {
    common = {
      default = [
        "gtk"
        "gnome"
      ];
    };
  };

  services.tuned.enable = true;

  # nali's nix-community key does not match upstream
  # (nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=).
  # nix.settings.substituters = [
  #   "https://cache.nixos.org"
  #   "https://nix-community.cachix.org"
  #   "https://cache.garnix.io"
  # ];
  # nix.settings.trusted-public-keys = [
  #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCUSeBc="
  #   "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  # ];
}
