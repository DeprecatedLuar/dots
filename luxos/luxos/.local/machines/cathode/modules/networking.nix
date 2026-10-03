{ ... }:

{
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  # Keep DHCP-provided DNS out of resolv.conf so only the servers above are used
  networking.networkmanager.dns = "none";
}
