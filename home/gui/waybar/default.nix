{ config, pkgs, lib, ... }:
let
  cfg = config.wk.gui;

  inherit (lib) elemAt genList;
  inherit (lib.attrsets) listToAttrs nameValuePair;
  inherit (lib.strings) concatStringsSep fileContents;

  font-size = config.wk.gui.font.base-size;

  numSteps = 21;
  steps = genList (x: 100 - (x * 5)) numSteps;
  strSteps = map toString steps;
  stepPair = n: nameValuePair "percent${toString n}" n;

  stepped-states = listToAttrs (map stepPair steps);

  constSteps = val: genList (x: val) numSteps;
  bgSteps = f: module: colours: concatStringsSep "\n"
    (genList
      (i: f module (elemAt strSteps i) (elemAt colours i))
      numSteps
    );
  fillBgSteps = bgSteps (module: step: colour: ''
    #${module}.percent${step} {
      background: linear-gradient(to top, #${colour} ${step}%,
                                  rgba(255,255,255,0.2) ${step}%);
    }'');
  colourBgSteps = bgSteps (module: step: colour: ''
    #${module}.percent${step} {
      background-color: #${colour};
    }'');
in
{
  programs.waybar = {
    enable = true;
    style = concatStringsSep "\n\n" [
      ''
        * {
            font-family: "NotoSans Nerd Font";
            font-size: ${toString font-size}pt;
        }''
      (fileContents ./style.css)
      (colourBgSteps "cpu" [
        "e50000"
        "e4483c"
        "de5425"
        "d85e00"
        "d16500"
        "ca6c00"
        "c37100"
        "bc7600"
        "b57a00"
        "af7d00"
        "a87f00"
        "a18200"
        "9a8400"
        "938500"
        "8c8700"
        "858823"
        "7d892f"
        "758b38"
        "6c8b41"
        "628c49"
        "578c50"
      ]
      )
      (fillBgSteps "battery" [
        "0ec971"
        "1ec76e"
        "2ec56b"
        "3ec368"
        "4ec165"
        "5ec062"
        "6ebe5f"
        "7ebd5c"
        "8ebb59"
        "aeb853"
        "c2b650"
        "d5b44c"
        "e9b248"
        "fcaf45"
        "fc973f"
        "fc7f38"
        "fc6731"
        "fc4e2a"
        "fc3524"
        "fd1d1d"
        "ffffff"
      ]
      )
      (fillBgSteps "memory" (constSteps "9b59b6"))
      (fillBgSteps "pulseaudio" (constSteps "884aa2"))
    ];
    settings = [
      ({
        layer = "top";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "cpu"
        ] ++ lib.lists.optional cfg.tray.battery "battery" ++
        [
          "tray"
          "clock"
        ];
        clock = {
          format = " {:%a, %b %d %H:%M}";
        };
        cpu = {
          format = "";
          interval = 5;
          max-length = 10;
          states = stepped-states;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        #          memory = {
        #            format = "";
        #            states = stepped-states;
        #          };
        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "{volume}% {icon}";
          format-icons = {
            car = "";
            default = [ "" "" ];
            hands-free = "";
            headphone = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = "";
          states = stepped-states;
        };
        "sway/window" = {
          max-length = 70;
        };
        "sway/workspaces" = {
          disable-scroll = true;
          format = "{icon} {name}";
          format-icons = {
            "1" = "";
            default = "";
            urgent = "";
          };
        };
        tray = {
          icon-size = (font-size - 1) * 2;
          spacing = font-size / 2;
        };
      } // lib.optionalAttrs
        cfg.tray.battery
        {
          battery = {
            format = "";
            format-charging = "";
            format-discharging = "";
            format-discharging-percent0 = "";
            format-discharging-percent10 = "";
            format-discharging-percent15 = "";
            format-discharging-percent5 = "";
            format-full = "";
            states = stepped-states;
          };
        })
    ];
  };
}
