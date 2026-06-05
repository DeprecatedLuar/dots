{ pkgs, ... }:

{
  #──[Packages]───────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    # VPS-specific packages can go here if needed
  ];

  #──[Network]────────────────────────────────────────────────────────────────

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ ];  # Add ports as needed
  };

  #──[Services]───────────────────────────────────────────────────────────────

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
    };
  };

  # Tailscale VPN
  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = [ "--accept-dns=false" ];

  # SSH authorized keys
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfrCrs58DjL/Y2FI+9hS+0dVRglxcMfIb9aiALctrrZ luar"
  ];

  users.users.luar.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfrCrs58DjL/Y2FI+9hS+0dVRglxcMfIb9aiALctrrZ luar"
  ];
}
