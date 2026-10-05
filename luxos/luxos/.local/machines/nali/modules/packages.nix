{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    #──[CLI]──────────────────────────────────────────────────────────────────
    jq ripgrep fd btop fzf gh
    zip unzip bat dig tldr fastfetch ncdu
    qemu

    #──[Viewers]──────────────────────────────────────────────────────────────
    mpv zathura imv

    #──[Editing]──────────────────────────────────────────────────────────────
    ffmpeg obs-studio

    #──[Programming]─────────────────────────────────────────────────────────
    gcc
    arrow-cpp
    gnumake
    cmake
    nodejs
    go
    cargo rustc
    delve
    python3
    openjdk
    gopls
    lua-language-server
    pyright
    nil
    nixpkgs-fmt
    oracle-instantclient
    claude-code

    #──[Terminal]─────────────────────────────────────────────────────────────
    kitty

    #──[Niri desktop]─────────────────────────────────────────────────────────
    wl-clipboard wtype
    xdg-desktop-portal-gtk xdg-desktop-portal-gnome
    xwayland-satellite

    grim slurp swappy
    wf-recorder
    brightnessctl

    adw-gtk3
    gnome-themes-extra
    papirus-icon-theme

    #──[Shell]────────────────────────────────────────────────────────────────
    evtest bemenu
  ];

  #──[Programs]───────────────────────────────────────────────────────────────

  programs.neovim.enable = true;
  programs.yazi.enable = true;
  programs.nh.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    baseIndex = 1;
  };
}
