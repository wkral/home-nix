{ config, pkgs, lib, ... }:
let
  inherit (lib) elemAt genList;
  inherit (lib.attrsets) listToAttrs nameValuePair;
  inherit (lib.strings) concatStringsSep fileContents;

  font-size = config.wk.font.base-size;

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
    systemd.enable = true;
    style = concatStringsSep "\n\n" [
      ''
        * {
            font-family: "Noto Sans";
            font-size: ${toString font-size}pt;
        }''
      (fileContents ./style.css)
      (colourBgSteps "cpu" [
        "fd1d1d"
        "fc4227"
        "fc6631"
        "fc8b3b"
        "fcaf45"
        "f1ac50"
        "e5a85a"
        "daa565"
        "cea16f"
        "c29e7a"
        "b69a85"
        "aa9790"
        "9e939b"
        "9290a6"
        "868cb1"
        "7a89bc"
        "6e86c7"
        "6283d2"
        "5680dd"
        "4a7de8"
        "417af0"
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
      (fillBgSteps "pulseaudio" (constSteps "f1c40f"))
    ];
    settings = [
      {
        layer = "top";
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "memory"
          "cpu"
          "battery"
          "tray"
          "clock"
        ];
        modules = {
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
          memory = {
            format = "";
            states = stepped-states;
          };
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
        };
      }
    ];
  };
}
