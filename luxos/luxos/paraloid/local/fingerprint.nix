{ pkgs, ... }:

{
  #──[Fingerprint Reader — Goodix 27c6:639c]───────────────────────────────────
  # Detected on the USB bus as "Goodix USB2.0 MISC". Supported by libfprint's
  # open driver since 1.90+; if enrollment fails with CRC/protocol errors,
  # switch to the proprietary TOD blob below instead.

  services.fprintd.enable = true;
  # services.fprintd.tod.enable = true;
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;
}
