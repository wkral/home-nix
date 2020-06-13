{ pkgs, ... }:
{
  programs.htop = {
    hideThreads = true;
    hideKernelThreads = true;
    hideUserlandThreads = true;
    treeView = true;
    meters = {
      left = [ "LeftCPUs" "Memory" "Swap" "Clock" ];
      right = [ "RightCPUs" "Tasks" "LoadAverage" "Uptime" ];
    };
  };
}
