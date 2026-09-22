{ ... }:

{
  #──[Power Management]──────────────────────────────────────────────────────

  powerManagement.enable = true;

  # auto-cpufreq owns CPU scaling; the other daemons would fight it.
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger.turbo = "auto";
      battery.turbo = "never";
    };
  };

  #──[Lid Switch]────────────────────────────────────────────────────────────

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };
}
