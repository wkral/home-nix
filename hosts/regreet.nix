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
          font_name = "Noto Sans 18";
          theme_name = "Dracula";
          icon_theme_name = "dracula";
          cursor_theme_name = "Bivata-Modern-Ice";
          application_prefer_dark_theme = true;
        };
      };
    };
}
