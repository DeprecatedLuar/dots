{ frameworkModules, ... }:
{
  imports = [ (frameworkModules + "/x11.nix") ];

  services.xserver.desktopManager.xfce.enable = true;
}
