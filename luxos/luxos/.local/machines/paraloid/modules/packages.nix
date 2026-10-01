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
    unstable.zapzap
#   equibop # idk why its broken on wayland so far
    telegram-desktop
    
    megacmd
    whisper-cpp
    scrcpy
    android-tools
    wf-recorder
	wlopm
	swayidle
	unstable.lf
    
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
