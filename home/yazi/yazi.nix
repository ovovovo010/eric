{ pkgs, ... }:

let
  yaziPluginsRepo = pkgs.fetchFromGitHub {
    owner  = "yazi-rs";
    repo   = "plugins";
    rev    = "196281844b8cbcac658a59013e4805300c2d6126";
    sha256 = "sha256-pAkBlodci4Yf+CTjhGuNtgLOTMNquty7xP0/HSeoLzE=";
  };

  fromMonorepo = name: "${yaziPluginsRepo}/${name}.yazi";

  bookmarksPlugin = pkgs.fetchFromGitHub {
    owner  = "dedukun";
    repo   = "bookmarks.yazi";
    rev    = "9ef1254d8afe88aba21cd56a186f4485dd532ab8";
    sha256 = "sha256-GQFBRB2aQqmmuKZ0BpcCAC4r0JFKqIANZNhUC98SlwY=";
  };

  frPlugin = pkgs.fetchFromGitHub {
    owner  = "lpnh";
    repo   = "fr.yazi";
    rev    = "aa88cd4d4345c07345275291c1a236343f834c86";
    sha256 = "sha256-3D1mIQpEDik0ppPQo+/NIhCxEu/XEnJMJ0HiAFxlOE4=";
  };

  ouchPlugin = pkgs.fetchFromGitHub {
    owner  = "ndtoan96";
    repo   = "ouch.yazi";
    rev    = "406ce6c13ec3a18d4872b8f64b62f4a530759b2c";
    sha256 = "sha256-14x/bD0aD9hXONaqQD8Dt7rLBCMq7bkVLH6uCPOQ0C8=";
  };
in
{
  programs.yazi = {
    enable = true;

    # ── Plugins ──────────────────────────────────────────────────────────────
    plugins = {
      # 預覽增強（來自 yazi-rs/plugins monorepo）
      "hexyl"        = fromMonorepo "hexyl";        # 二進位 hex 預覽
      "miller"       = fromMonorepo "miller";       # CSV/TSV 預覽
      "exifaudio"    = fromMonorepo "exifaudio";    # 音樂 metadata
      "mediainfo"    = fromMonorepo "mediainfo";    # 影音 metadata
      "git"          = fromMonorepo "git";          # git 狀態標記
      "jump-to-char" = fromMonorepo "jump-to-char"; # 單鍵跳字元

      # 獨立 repo
      "bookmarks"    = bookmarksPlugin;             # 持久書籤
      "fr"           = frPlugin;                    # fzf + ripgrep 搜尋
      "ouch"         = ouchPlugin;                  # 壓縮 / 解壓
    };

    # ── 初始化 ────────────────────────────────────────────────────────────────
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
        { on = ["<C-g>"]; run = "plugin git";           desc = "Toggle git status"; }
        { on = ["f"];     run = "plugin jump-to-char";  desc = "Jump to char"; }
        { on = ["b" "m"]; run = "plugin bookmarks --args=save";   desc = "Save bookmark"; }
        { on = ["b" "j"]; run = "plugin bookmarks --args=jump";   desc = "Jump to bookmark"; }
        { on = ["b" "d"]; run = "plugin bookmarks --args=delete"; desc = "Delete bookmark"; }
        { on = ["<C-f>"]; run = "plugin fr";            desc = "fzf ripgrep search"; }
        { on = ["x"];     run = "plugin ouch --args=extract";     desc = "Extract archive"; }
        { on = ["X"];     run = "plugin ouch --args=compress";    desc = "Compress to archive"; }
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
      preview = {
        max_width  = 1000;
        max_height = 1000;
      };
    };
  };
}
