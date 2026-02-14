{ lib, ... }:

let
  # Config directory is parent of system/ directory
  configDir = dirOf ./.;

  # Read services config if it exists
  servicesFile = "${configDir}/services/services.nix";
  enabledServices = if builtins.pathExists servicesFile
    then (import servicesFile { }).enabledServices
    else [ ];

  # Map service names to their file paths
  serviceImports = map (name: "${configDir}/services/available/${name}.nix") enabledServices;

in
{
  imports = serviceImports;
}
