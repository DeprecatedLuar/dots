# Avoids a fcitx5-qt segfault on QML TextInput focus; scoped to ambxst only.
{ pkgs }:
pkg:
pkgs.symlinkJoin {
  inherit (pkg) name meta;
  paths = [ pkg ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/ambxst --unset QT_IM_MODULE --unset XMODIFIERS";
}
