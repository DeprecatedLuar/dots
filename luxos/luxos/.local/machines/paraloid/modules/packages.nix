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
    
    megacmd
    whisper-cpp
    scrcpy
    android-tools
    wf-recorder
    opencode
    ollama
	wlopm
	swayidle
    
    nwg-wrapper
    quickshell

    # Hardware video acceleration diagnostics
    libva-utils
    v4l-utils

    # RAM stability testing
    memtester
    stressapptest

    (wrapOBS {
      plugins = with obs-studio-plugins; [ obs-pipewire-audio-capture ];
    })
  ];
}
