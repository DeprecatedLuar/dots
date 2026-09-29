{ ... }:

{
  # Router DNS (192.168.0.1) intermittently fails to answer queries.
  # Fallback resolvers prevent builds/updates from stalling on that.
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
}
