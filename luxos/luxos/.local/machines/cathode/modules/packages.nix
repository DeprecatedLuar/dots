{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    unstable.noctalia
   
    
#    libreoffice
    rofi
    audacity
    mailspring
    thunderbird
    anki
    pcmanfm-qt
    netlogo
    xournalpp
    qpwgraph
    cool-retro-term
    swayimg
    zapzap
    hydralauncher   

    megacmd
    whisper-cpp
    scrcpy
    android-tools
    wf-recorder
    opencode
    ollama
    claude-code

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
