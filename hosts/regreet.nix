{ pkgs, ... }: {
  programs.regreet =
    let
      background = pkgs.fetchurl
        {
          url = "https://w.wallhaven.cc/full/4o/wallhaven-4owxz7.jpg";
          sha256 = "1cga9vzwbaa63xcfh8i6j8c88rrlxv5gv5awl3409swfhqfd6c3b";
        };
    in
    {
      enable = true;
      settings = {
        background = {
          path = background;
          fit = "Cover";
        };
        GTK = {
          application_prefer_dark_theme = true;
        };
      };
      theme = {
        package = pkgs.dracula-theme;
        name = "Dracula";
      };
      iconTheme = {
        package = pkgs.tela-circle-icon-theme;
        name = "Tela-circle-dracula-dark";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };
      font = { 
        package = pkgs.noto-fonts;
        name = "Noto Sans";
        size = 18;
      };
    };
}
