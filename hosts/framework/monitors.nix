{ ... }:
{
  services.kanshi.profiles = {
    solo = {
      outputs = [
        {
          criteria = "eDP-1";
          status = "enable";
          scale = 2.0;
          mode = "2256x1504@60Hz";
        }
      ];
    };
    livingroom-tv = {
      outputs = [
        {
          criteria = "Sharp Corporation SHARP HDMI 0x00000101";
          status = "enable";
          mode = "1920x1080@60Hz";
        }
      ];
    };
  };
}
