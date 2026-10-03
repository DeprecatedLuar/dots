{ pkgs, luxos, ... }:

{
  imports = luxos.modules [ "unstable" ];

  #──[Power Management]──────────────────────────────────────────────────────

  powerManagement.enable = true;

  # TLP owns power management; the other daemons would fight it.
  services.power-profiles-daemon.enable = false;
  # services.auto-cpufreq = {
  #   enable = true;
  #   settings = {
  #     charger.turbo = "auto";
  #     battery.turbo = "never";
  #   };
  # };

  # Profile settings need TLP 1.10+, which only unstable ships.
  services.tlp = {
    enable = true;
    package = pkgs.unstable.tlp;
    settings = {
      TLP_AUTO_SWITCH = 1;
      TLP_PROFILE_AC = "PRF";
      TLP_PROFILE_BAT = "SAV";
      CPU_BOOST_ON_SAV = 0;
    };
  };

  # tlp-pd: power-profiles-daemon D-Bus API for TLP, so desktop profile widgets drive it.
  # The stable tlp module has no pd option; this mirrors unstable's wiring.
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
