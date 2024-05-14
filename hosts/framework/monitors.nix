{ ... }:
{
  services.kanshi.settings = [
    {
     profile.name = "solo";
     profile.outputs = [{
        criteria = "eDP-1";
        status = "enable";
        scale = 2.0;
        mode = "2256x1504@60Hz";
      }];
    }
    {
      profile.name = "livingroom-tv";
      profile.outputs = [{
          criteria = "Sharp Corporation SHARP HDMI 0x00000101";
          status = "enable";
          mode = "1920x1080@60Hz";
      }];
    }
  ];
}
