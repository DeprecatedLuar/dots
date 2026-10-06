{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go gotools golangci-lint go-tools govulncheck
    python3
    nodejs
    cargo
    rustc
    gcc
    gh
  ];
}
