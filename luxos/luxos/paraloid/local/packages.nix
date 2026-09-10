{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [

    inputs.ambxst.packages.${pkgs.system}.default

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
    
    unstable.caelestia-shell

    megacmd
    whisper-cpp
    scrcpy
    android-tools
    wf-recorder
    opencode
    ollama

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
