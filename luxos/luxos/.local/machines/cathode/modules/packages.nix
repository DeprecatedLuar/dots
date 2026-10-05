{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

   
   
# GUI
    rofi   
    pcmanfm-qt   
    qpwgraph
    cool-retro-term
    swayimg
    zapzap
    telegram-desktop
    hydralauncher   
    unstable.atlauncher unstable.xwayland-satellite unstable.libxkbcommon unstable.libxrender

# CLI
    whisper-cpp
    scrcpy
    android-tools      
    ollama   
    swayidle
    unstable.noctalia
    nwg-wrapper
    quickshell

# TUI
	unstable.hyprmon
    unstable.claude-code   

    # Hardware video acceleration diagnostics
    libva-utils
    v4l-utils

    (wrapOBS {
      plugins = with obs-studio-plugins; [ obs-pipewire-audio-capture ];
    })
  ];

  # Native .so files extracted at runtime resolve their deps through nix-ld.
  programs.nix-ld.libraries = with pkgs; [
    unstable.libxkbcommon
    unstable.libxrender
  ];
}
