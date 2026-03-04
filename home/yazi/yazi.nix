{
  programs.yazi = {
    enable = true;
    settings = {
      opener = {
        # 預設編輯器為 nvim
        edit = [
          { run = "nvim \"$1\""; desc = "Edit in Neovim"; block = true; }
        ];
        open = [
          { run = "xdg-open \"$1\""; desc = "Open with default"; }
        ];
      };
    };
  };
}
