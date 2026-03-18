{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    # ── Plugins ──────────────────────────────────────────────────────────────
    plugins = {
      # 預覽增強
      "hexyl"       = pkgs.yaziPlugins.hexyl;        # 二進位 hex 預覽
      "miller"      = pkgs.yaziPlugins.miller;       # CSV/TSV 預覽
      "exifaudio"   = pkgs.yaziPlugins.exifaudio;    # 音樂 metadata
      "mediainfo"   = pkgs.yaziPlugins.mediainfo;    # 影音 metadata

      # Git
      "git"         = pkgs.yaziPlugins.git;          # 檔案 git 狀態標記

      # 跳轉 / 書籤
      "jump-to-char" = pkgs.yaziPlugins.jump-to-char; # 單鍵跳到字元
      "bookmarks"   = pkgs.yaziPlugins.bookmarks;    # 持久書籤

      # 搜尋
      "fg"          = pkgs.yaziPlugins.fg;           # fzf + ripgrep 全文搜尋

      # 壓縮 / 解壓
      "ouch"        = pkgs.yaziPlugins.ouch;         # ouch 解壓縮整合
    };

    # ── 初始化（每次啟動執行）────────────────────────────────────────────────
    initLua = ''
      require("git"):setup()
      require("bookmarks"):setup({
        last_directory = { enable = true, persist = true },
        persist        = "all",
        desc_format    = "full",
        notify         = { enable = true, timeout = 1 },
      })
    '';

    # ── Keymap ────────────────────────────────────────────────────────────────
    keymap = {
      manager.prepend_keymap = [
        # Git：切換 git 狀態側邊欄
        { on = ["<C-g>"]; run = "plugin git"; desc = "Toggle git status"; }

        # 跳轉
        { on = ["f"];     run = "plugin jump-to-char"; desc = "Jump to char"; }

        # 書籤
        { on = ["b" "m"]; run = "plugin bookmarks --args=save";   desc = "Save bookmark"; }
        { on = ["b" "j"]; run = "plugin bookmarks --args=jump";   desc = "Jump to bookmark"; }
        { on = ["b" "d"]; run = "plugin bookmarks --args=delete"; desc = "Delete bookmark"; }

        # 全文搜尋 (fg)
        { on = ["<C-f>"]; run = "plugin fg";    desc = "fzf ripgrep search"; }

        # 解壓縮（選取後按 x）
        { on = ["x"];     run = "plugin ouch --args=extract"; desc = "Extract archive"; }
        # 壓縮（選取後按 X）
        { on = ["X"];     run = "plugin ouch --args=compress"; desc = "Compress to archive"; }
      ];
    };

    # ── Settings ──────────────────────────────────────────────────────────────
    settings = {
      opener = {
        edit = [
          { run = "nvim \"$1\""; desc = "Edit in Neovim"; block = true; }
        ];
        open = [
          { run = "xdg-open \"$1\""; desc = "Open with default"; }
        ];
      };

      # 預覽：對應 plugin
      preview = {
        max_width  = 1000;
        max_height = 1000;
      };
    };
  };
}
