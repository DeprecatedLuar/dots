{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go
    python3
    nodejs
    cargo
    rustc
    gcc
    gh
  ];
}
