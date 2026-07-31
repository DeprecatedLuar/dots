{ pkgs, ... }:

{
  #──[Packages]───────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Machine-specific packages
  ];

  #──[Network]────────────────────────────────────────────────────────────────
  networking.networkmanager.enable = true;
}
