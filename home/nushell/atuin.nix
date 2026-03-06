# home/nushell/atuin.nix
{ ... }: {
  programs.atuin = {
    enable = true;
    enableNushellIntegration = false; # 手動在 nushell.nix 載入（避免雙重綁定）
    settings = {
      auto_sync    = false;
      update_check = false;
      style        = "compact";
      inline_height = 20;
      show_preview  = true;
      filter_mode_shell_up_key_binding = "session";
      keymap_mode  = "vim-insert";
      enter_accept = true;
    };
  };
}
