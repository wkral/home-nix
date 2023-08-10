{ ... }:
{
  services.kanshi.profiles = {
    solo = {
      outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          mode = "800x1280@60Hz";
          transform = "270";
        }
      ];
    };
    livingroom-tv = {
      outputs = [
        {
          criteria = "eDP-1";
          status = "disable";
        }
        {
          criteria = "Sharp Corporation SHARP HDMI 0x00000101";
          status = "enable";
          mode = "1920x1080@60Hz";
        }
      ];
    };
  };
}
