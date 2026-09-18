{ pkgs, ... }:

{
  programs.zoxide.enable = true;

  networking.firewall.allowedUDPPortRanges = [
    { from = 60000; to = 61000; }  # mosh
  ];

  environment.systemPackages = with pkgs; [
    eza
    ripgrep
    fd
    bat
    fzf
    micro
    mosh
  ];

  environment.shellAliases = {
    ls = "eza";
    ll = "eza -lah --git";
    la = "eza -a";

    lt = "eza --tree --level=1";
    lt0 = "eza --tree";
    lt2 = "eza --tree --level=2";
    lt3 = "eza --tree --level=3";
    lt4 = "eza --tree --level=4";

    cat = "bat --paging=never --style=plain";
    nano = "micro";
  };
}
