{ config, lib, pkgs, ... }:
with lib;
{
  options.wk = {
    font = {
      base-size = mkOption {
        type = types.int;
        default = 9;
        example = 14;
        description = "Base font size for GUI layout";
      };
    };
    vim = {
      ale-fixers = mkOption {
        type = with types; attrsOf (listOf str);
        default = { };
        example = {
          json = [ "jq" ];
        };
        description = "Fixers in Vim-ALE to be used for filetypes";
      };
    };
  };

  imports = [
    ./pkgs
    ./modules
    ./configuration.nix

    ./config/vim
    ./config/git.nix
    ./config/htop.nix
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
      du-dust
      qrencode
      yj
      fd
      (pass.withExtensions (exts: [ exts.pass-otp ]))
      git-crypt
      starship

      shfmt
    ];

    home = {
      sessionVariables = {
        EDITOR = "vim";
      };
      file = {
        ".inputrc".source = ./config/inputrc;
      };
    };

    xdg = {
      enable = true;
      configFile = {
        "starship.toml".source = ./config/starship.toml;
      };
    };

    systemd.user.startServices = true;

    programs = {
      bash = {
        enable = true;
        shellAliases = {
          vi = "vim";
        };
        initExtra = ''
          function set_win_title(){
            echo -ne "\033]0; $USER@$HOSTNAME:$PWD \007"
          }
          starship_precmd_user_func="set_win_title"
          source <("${pkgs.starship}/bin/starship" init bash --print-full-init)
        '';
      };
      broot = {
        enable = true;
        enableBashIntegration = true;
      };
      fzf = {
        enable = true;
        defaultCommand = "rg --files --follow --no-ignore-exclude";
      };
      gpg.enable = true;
      git.enable = true;
      htop.enable = true;
      jq.enable = true;
      vim.enable = true;
    };

    wk.vim.ale-fixers = {
      json = [ "jq" ];
      bash = [ "shfmt" ];
      sh = [ "shfmt" ];
    };
  };

}
