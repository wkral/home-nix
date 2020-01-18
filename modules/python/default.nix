{pkgs, ...}:
let
  py = pkgs.python3;
  tools = py-pkgs:
  with py-pkgs; [
    yapf
    flake8
    isort
  ];
  python-dev-tools = py.withPackages tools;
in
{
  home.packages = [
    python-dev-tools
  ];
}
