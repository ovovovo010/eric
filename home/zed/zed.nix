{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;

    # ── 語言伺服器 / 外部工具 ─────────────────────────────────────────────────
    extraPackages = with pkgs; [
      nil # Nix LSP
      nixpkgs-fmt # Nix formatter
      alejandra # 備用 Nix formatter
      nushell # Nu LSP（nu --lsp）
      taplo # TOML LSP + formatter
      marksman # Markdown LSP
    ];

    extensions = [
      # ── 語言支援 ────────────────────────────────────────────────────────────
      "nix"
      "nu" # Nushell 語法 + LSP
      "toml"
      "json"
      "markdown"
      "html"
      "xml"
      "sql"
      "dockerfile"
      "just" # Justfile
      "env" # .env 語法
      "log" # log 檔語法高亮
      "editorconfig" # .editorconfig 支援
      "rainbow-csv" # CSV 彩色欄位

      # ── Git 整合 ─────────────────────────────────────────────────────────────
      "git-firefly" # git blame / diff / log 整合

      # ── AI ───────────────────────────────────────────────────────────────────
      "supermaven" # 免費 AI 補全，原生支援，速度快

      # ── 圖示主題 ─────────────────────────────────────────────────────────────
      "catppuccin-icons"
    ];

    userSettings = {
      # ── AI 補全（Supermaven） ────────────────────────────────────────────────
      # 第一次開啟後執行 `supermaven: sign in` 登入，完全免費
      edit_predictions = {
        mode = "eager";
      };

      # ── 圖示主題 ─────────────────────────────────────────────────────────────
      icon_theme = "Catppuccin";

      # ── Vim ──────────────────────────────────────────────────────────────────
      vim_mode = true;
      vim = {
        use_system_clipboard = "always";
        use_multiline_find = true;
        use_smartcase_find = true;
      };

      # ── 字型（顏色交給 Stylix） ───────────────────────────────────────────────
      ui_font_family = "JetBrainsMono Nerd Font Mono";
      ui_font_size = 14;
      buffer_font_family = "JetBrainsMono Nerd Font Mono";
      buffer_font_size = lib.mkForce 14;
      buffer_line_height = "comfortable";

      # ── 編輯器行為 ────────────────────────────────────────────────────────────
      autosave = "on_focus_change";
      format_on_save = "on";
      confirm_quit = false;
      restore_on_startup = "last_workspace";
      tab_size = 2;
      hard_tabs = false;
      soft_wrap = "editor_width";
      show_whitespaces = "selection";
      cursor_blink = false;
      relative_line_numbers = true; # vim 使用者必備

      # ── 縮排導引 ─────────────────────────────────────────────────────────────
      indent_guides = {
        enabled = true;
        line_width = 1;
        coloring = "indent_aware"; # 不同縮排層次不同顏色
      };

      # ── Inlay hints ──────────────────────────────────────────────────────────
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_other_hints = true;
        show_parameter_hints = true;
      };

      # ── Scrollbar ────────────────────────────────────────────────────────────
      scrollbar = {
        show = "auto";
        git_diff = true;
        search_results = true;
        selected_symbol = true;
        diagnostics = "all";
      };

      # ── Git ──────────────────────────────────────────────────────────────────
      git = {
        git_gutter = "tracked_files";
        inline_blame = {
          enabled = true;
          delay_ms = 600;
        };
      };

      # ── Terminal（Nushell） ───────────────────────────────────────────────────
      terminal = {
        font_family = "JetBrainsMono Nerd Font Mono";
        font_size = 13;
        shell = {program = "nu";};
        copy_on_select = true;
        dock = "bottom";
      };

      # ── 檔案瀏覽器 ────────────────────────────────────────────────────────────
      project_panel = {
        dock = "left";
        git_status = true;
        file_icons = true;
        folder_icons = true;
        indent_size = 16;
        auto_reveal_entries = true;
      };

      # ── 大綱面板 ─────────────────────────────────────────────────────────────
      outline_panel = {
        dock = "right";
        git_status = true;
        file_icons = true;
      };

      # ── 搜尋 ─────────────────────────────────────────────────────────────────
      search = {
        whole_word = false;
        case_sensitive = false;
        include_ignored = false;
        regex = false;
      };

      # ── 檔案排除 ─────────────────────────────────────────────────────────────
      file_scan_exclusions = [
        "**/.git"
        "**/node_modules"
        "**/.direnv"
        "**/.cache"
        "**/result"
        "**/.nix-*"
        "**/__pycache__"
        "**/.venv"
      ];

      # ── 語言個別設定 ──────────────────────────────────────────────────────────
      languages = {
        Nix = {
          tab_size = 2;
          formatter = {external = {command = "nixpkgs-fmt";};};
          language_servers = ["nil"];
        };
        Nu = {
          tab_size = 4;
          language_servers = ["nu"];
        };
        TOML = {
          tab_size = 2;
          formatter = {language_server = {language_server_name = "taplo";};};
          language_servers = ["taplo"];
        };
        Markdown = {
          soft_wrap = "editor_width";
          format_on_save = "off";
          language_servers = ["marksman"];
        };
        SQL = {
          tab_size = 2;
        };
      };

      # ── LSP 設定 ─────────────────────────────────────────────────────────────
      lsp = {
        nil = {
          settings = {
            nil = {
              formatting = {command = ["nixpkgs-fmt"];};
              nix = {
                flake = {
                  autoArchive = true;
                  autoEvalInputs = false;
                };
              };
            };
          };
        };

        nu = {
          binary = {
            path = "nu";
            arguments = ["--lsp"];
          };
        };

        taplo = {
          config = {
            formatter = {
              align_entries = false;
              array_trailing_comma = true;
              compact_arrays = false;
            };
          };
        };
      };
    };
  };
}
