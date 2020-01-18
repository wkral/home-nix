{pkgs, ...}:
{
  home.packages = [
    pkgs.ripgrep
  ];

  programs.fzf = {
    enable = true;
    defaultCommand = "rg --files --follow";
  };
}
