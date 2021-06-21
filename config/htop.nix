{ pkgs, ... }:
{
  programs.htop.settings = {
    hide_threads = true;
    hide_kernel_threads = true;
    hide_userland_threads = true;
    tree_view = true;
    left_meters = [ "LeftCPUs" "Memory" "Swap" "Clock" ];
    right_meters = [ "RightCPUs" "Tasks" "LoadAverage" "Uptime" ];
  };
}
