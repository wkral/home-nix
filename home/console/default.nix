{
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
{
  options.wk = {
    git = {
      user_email = mkOption {
        type = types.str;
        default = "william.kral@gmail.com";
        example = "user@example.com";
        description = "User email for git config";
      };
    };
  };

  imports = [
    inputs.nixvim.homeModules.default
    ./git.nix
    ./neovim.nix
    ../dev/python.nix
    ../dev/nix.nix
  ];

  config = {
    home.packages = with pkgs; [
      file
      gnumake
      ripgrep
      nnn
      unzip
      openssl
      dnsutils
      zip
      tree
      dust
      qrencode
      yj
      fd
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      starship
    ];

    home.file.".inputrc".source = ./inputrc;

    xdg = {
      enable = true;
      configFile = {
        "starship.toml".source = ./starship.toml;
      };
    };

    programs = {
      bash = {
        enable = true;
        initExtra = ''
          function set_win_title(){
            echo -ne "\033]0; $USER@$HOSTNAME:$PWD \007"
          }
          starship_precmd_user_func="set_win_title"
          source <("${pkgs.starship}/bin/starship" init bash --print-full-init)
          source ${pkgs.pass.extensions.pass-otp}/share/bash-completion/completions/pass-otp
        '';
      };
      bottom.enable = true;
      fzf = {
        enable = true;
        defaultCommand = "rg --files --follow --no-ignore-exclude";
      };
      gpg.enable = true;
      git.enable = true;
      jq.enable = true;
      vim = {
        enable = true;
        extraConfig = (builtins.readFile ./vimrc);
        plugins =
          with pkgs.vimPlugins;
          with pkgs.wk.vimPlugins;
          [
            vim-fugitive
            fzf-vim
            vim-gitgutter
            lightline-vim
            editorconfig-vim
            colours
          ];
      };
    };
  };
}
