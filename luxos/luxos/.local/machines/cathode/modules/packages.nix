{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    unstable.noctalia
   
    
    rofi   
    pcmanfm-qt   
    qpwgraph
    cool-retro-term
    swayimg
    zapzap
    hydralauncher   

    megacmd
    whisper-cpp
    scrcpy
    android-tools      
    ollama
    unstable.claude-code
    unstable.hyprmon

    nwg-wrapper
    quickshell

    # Hardware video acceleration diagnostics
    libva-utils
    v4l-utils

    (wrapOBS {
      plugins = with obs-studio-plugins; [ obs-pipewire-audio-capture ];
    })
  ];
}
