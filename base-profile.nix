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
      ale-linters = mkOption {
        type = with types; attrsOf (listOf str);
        default = { };
        example = {
          ryst = [ "analyzer" ];
        };
        description = "Linters in Vim-ALE to be used for filetypes";
      };
    };
  };

  imports = [
    ./pkgs
    ./modules

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
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableVteIntegration = true;
        autocd = true;
        defaultKeymap = "viins";
        dotDir = ".config/zsh";
        history = {
          extended = true;
          path = ".cache/zsh/zsh_history";
        };
        envExtra = ''
          export KEYTIMEOUT=1
        '';
        initExtra = ''
          function set_win_title(){
            echo -ne "\033]0; $USER@$HOSTNAME:$PWD \007"
          }
          precmd_functions+=(set_win_title)
        '';
        shellAliases = {
          vi = "vim";
        };
      };
      dircolors = {
        enable = true;
        enableZshIntegration = true;
      };
      starship = {
        enable = true;
        enableZshIntegration = true;
      };
      fzf = {
        enable = true;
        defaultCommand = "rg --files --follow --no-ignore-exclude";
        enableZshIntegration = true;
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
