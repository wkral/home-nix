{ ... }: {
  services.wayland-pipewire-idle-inhibit = {
    enable = true;
    systemdTarget = "niri.service";
  };
}

