{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    unstable.noctalia
   
    
# GUI
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
    unstable.atlauncher

# CLI    
    megacmd
    whisper-cpp
    scrcpy
    android-tools
    wf-recorder
	wlopm
	swayidle
	unstable.lf
    unstable.hyprmon
    nwg-wrapper
    quickshell



# ???
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
