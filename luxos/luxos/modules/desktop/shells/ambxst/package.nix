{ pkgs, lib, inputs }:

let
  src = inputs.ambxst;
  system = pkgs.stdenv.hostPlatform.system;
  version = lib.removeSuffix "\n" (builtins.readFile "${src}/version");

  backend = inputs.ambxst.packages.${system}.backend;
  axctl = inputs.ambxst.inputs.axctl.packages.${system}.default;

  ttf-phosphor-icons = import "${src}/nix/packages/phosphor-icons.nix" { inherit pkgs; };

  corePkgs = import "${src}/nix/packages/core.nix" { inherit pkgs; quickshellPkg = pkgs.quickshell; };
  fontsPkgs = import "${src}/nix/packages/fonts.nix" { inherit pkgs ttf-phosphor-icons; };

  requiredPkgs = with pkgs; [
    brightnessctl
    fontconfig
    git
    glib
    jq
    libnotify
    sqlite
    upower
    wl-clipboard
    wtype
    inetutils
    pipewire
    wireplumber
    kdePackages.breeze-icons
    hicolor-icon-theme
  ];

  envAmbxst = pkgs.buildEnv {
    name = "Ambxst-env";
    paths = corePkgs ++ [ axctl ] ++ requiredPkgs ++ fontsPkgs;
  };

  fontconfigConf = pkgs.writeTextDir "etc/fonts/conf.d/99-ambxst-fonts.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <dir>${envAmbxst}/share/fonts</dir>
    </fontconfig>
  '';

  launcher = pkgs.writeShellScriptBin "ambxst" ''
    export AMBXST_QS="${pkgs.quickshell}/bin/qs"
    export AMBXST_SHELL="${src}"
    export PATH="${envAmbxst}/bin:$PATH"

    # Set QML2_IMPORT_PATH to include modules from envAmbxst (like syntax-highlighting)
    export QML2_IMPORT_PATH="${envAmbxst}/lib/qt-6/qml:$QML2_IMPORT_PATH"
    export QML_IMPORT_PATH="$QML2_IMPORT_PATH"

    # Make bundled fonts available to fontconfig
    export FONTCONFIG_PATH="${fontconfigConf}/etc/fonts:''${FONTCONFIG_PATH:-}"

    # Delegate execution to the Go backend
    exec ${backend}/bin/ambxst "$@"
  '';

in
pkgs.buildEnv {
  name = "Ambxst-${version}";
  paths = [ envAmbxst launcher ];
  meta.mainProgram = "ambxst";
}
