{ config, ... }:
let
  cfg = config.wk.git;
in
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "William Kral";
      user.email = cfg.user_email;
      branch.sort = "-committerdate";
      color.ui = "auto";
      column.ui = "auto";
      commit.verbose = true;
      core = {
        editor = "nvim";
        ignorecase = false;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        tool = "vimdiff";
        renames = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3";
      pull = {
        rebase = "false";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      alias = {
        co = "checkout";
        lg = "log --graph --pretty=format:'%C(auto)%h %cd %d%n%s %C(245)- %cn%n'";
      };
    };
    ignores = [
      ".*.s[v-w][a-z]"
      ".s[v-w][a-z]"

      ".DS_Store"
      ".DS_Store?"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "ehthumbs.db"
      "Thumbs.db"
      ".ssh-config"
      "my-todo.md"
    ];
  };
}
