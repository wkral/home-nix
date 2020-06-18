{ ... }:
{
  programs.git = {
    userName = "William Kral";
    userEmail = "william.kral@gmail.com";
    extraConfig = {
      color = { ui = "auto"; };
      core = {
        editor = "vim";
        ignorecase = false;
      };
      push = { default = "simple"; };
      pull = { rebase = "false"; };
      diff = { tool = "vimdiff"; };
    };
    aliases = {
      co = "checkout";
      lg = "log --graph --pretty=format:'%C(auto)%h %cd %d%n%s %C(245)- %cn%n'";
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
