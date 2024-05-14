{ ... }:
{
  services.kanshi.settings = [
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
