{ ... }: {
  services.wayland-pipewire-idle-inhibit = {
    enable = true;
    systemdTarget = "sway-session.target";
  };
}

