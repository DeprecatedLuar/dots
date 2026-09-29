{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go
    gotools
    golangci-lint
    python3
    nodejs
    cargo
    rustc
    gcc
    gh
  ];
}
