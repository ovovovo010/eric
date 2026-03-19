{
  pkgs,
  inputs,
  ...
}: let
  yazi-pkg = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;

  yaziPluginsRepo = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "main";
    hash = pkgs.lib.fakeHash;
  };

  fromMonorepo = name: "${yaziPluginsRepo}/${name}.yazi";

  yazi-flavors = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "main";
    hash = "sha256-Og33IGS9pTim6LEH33CO102wpGnPomiperFbqfgrJjw=";
  };
in {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    package = yazi-pkg;

    flavors = {
      catppuccin-mocha = "${yazi-flavors}/flavors/mocha.yazi";
    };

    theme = {
      flavor = {
        dark = "catppuccin-mocha";
        light = "catppuccin-mocha";
      };
    };

    settings = {
      opener = {
        edit = [
          {
            run = "nvim \"$1\"";
            desc = "Edit in Neovim";
            block = true;
          }
        ];
        open = [
          {
            run = "xdg-open \"$1\"";
            desc = "Open with default";
          }
        ];
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    plugins = {
      "hexyl" = fromMonorepo "hexyl";
      "miller" = fromMonorepo "miller";
      "exifaudio" = fromMonorepo "exifaudio";
      "mediainfo" = fromMonorepo "mediainfo";
      "git" = fromMonorepo "git";
      "jump-to-char" = fromMonorepo "jump-to-char";
      "bookmarks" = pkgs.fetchFromGitHub {
        owner = "dedukun";
        repo = "bookmarks.yazi";
        rev = "main";
        hash = pkgs.lib.fakeHash;
      };
      "fr" = pkgs.fetchFromGitHub {
        owner = "lpnh";
        repo = "fr.yazi";
        rev = "main";
        hash = "sha256-3D1mIQpEDik0ppPQo+/NIhCxEu/XEnJMJ0HiAFxlOE4=";
      };
      "ouch" = pkgs.fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "main";
        hash = "sha256-14x/bD0aD9hXONaqQD8Dt7rLBCMq7bkVLH6uCPOQ0C8=";
      };
    };

    initLua = ''
      require("git"):setup()
      require("bookmarks"):setup({
        last_directory = { enable = true, persist = true },
        persist        = "all",
        desc_format    = "full",
        notify         = { enable = true, timeout = 1 },
      })
    '';

    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["<C-g>"];
          run = "plugin git";
          desc = "Toggle git status";
        }
        {
          on = ["f"];
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
        {
          on = ["b" "m"];
          run = "plugin bookmarks --args=save";
          desc = "Save bookmark";
        }
        {
          on = ["b" "j"];
          run = "plugin bookmarks --args=jump";
          desc = "Jump to bookmark";
        }
        {
          on = ["b" "d"];
          run = "plugin bookmarks --args=delete";
          desc = "Delete bookmark";
        }
        {
          on = ["<C-f>"];
          run = "plugin fr";
          desc = "fzf ripgrep search";
        }
        {
          on = ["x"];
          run = "plugin ouch --args=extract";
          desc = "Extract archive";
        }
        {
          on = ["X"];
          run = "plugin ouch --args=compress";
          desc = "Compress to archive";
        }
      ];
    };
  };
}
