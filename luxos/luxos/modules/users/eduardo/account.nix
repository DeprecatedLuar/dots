{ pkgs, ... }:

{
  users.users.eduardo = {
    isNormalUser = true;
    description = "Eduardo";
    initialPassword = "test";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    packages = with pkgs; [
    ];
  };
}
