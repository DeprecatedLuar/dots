{ frameworkModules, ... }:
{
  imports = [ (frameworkModules + "/wayland.nix") ];

  programs.niri.enable = true;
}
