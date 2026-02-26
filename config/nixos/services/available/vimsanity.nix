{ mainUser, ... }:

{
  services.kanata.enable = true;

  services.kanata.keyboards.vimsanity = {
    devices = [ ];
    configFile = /home/${mainUser}/Workspace/dev/going-vimsane/vimsanity.kbd;
    port = 5828;
  };
}
