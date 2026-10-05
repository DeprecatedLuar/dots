{ pkgs, luxos, ... }:

{
  imports = luxos.modules [ "unstable" ];

  #──[Power Management]──────────────────────────────────────────────────────

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = false;

  # Profile settings need TLP 1.10+, which only unstable ships.
  services.tlp = {
    enable = true;
    package = pkgs.unstable.tlp;
    settings = {
      TLP_AUTO_SWITCH = 1;
      TLP_PROFILE_AC = "PRF";
      TLP_PROFILE_BAT = "SAV";

      # All three, or turbo stays off after the first power-saver switch.
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;
      CPU_BOOST_ON_SAV = 0;

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_SAV = "power";
    };
  };

  environment.systemPackages = [ pkgs.unstable.tlp-pd ];
  systemd.packages = [ pkgs.unstable.tlp-pd ];
  systemd.services.tlp-pd.wantedBy = [ "graphical.target" ];

  #──[Lid Switch]────────────────────────────────────────────────────────────

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };
}
