{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias  = true;
    vimAlias = true;

    # ── 基礎選項 ────────────────────────────────────────────────
    opts = {
      number         = true;
      relativenumber = true;
      shiftwidth     = 2;
      tabstop        = 2;
      expandtab      = true;
      cursorline     = true;
      termguicolors  = true;
      signcolumn     = "yes";
      updatetime     = 250;
      splitright     = true;
      splitbelow     = true;
      scrolloff      = 8;
    };

    globals = {
      mapleader      = " ";
      maplocalleader = " ";
    };

    # ── Keymaps ─────────────────────────────────────────────────
    keymaps = [
      { mode = "n"; key = "<leader>e";  action = "<cmd>NvimTreeToggle<CR>"; options.desc = "Toggle File Tree"; }
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; options.desc = "Find Files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>";  options.desc = "Live Grep"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<CR>";    options.desc = "Buffers"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<CR>";  options.desc = "Help Tags"; }
      { mode = "n"; key = "<leader>t";  action = "<cmd>ToggleTerm<CR>";           options.desc = "Toggle Terminal"; }
      { mode = "n"; key = "<leader>gg"; action = "<cmd>LazyGit<CR>";             options.desc = "LazyGit"; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<CR>";     options.desc = "Next Buffer"; }
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<CR>"; options.desc = "Prev Buffer"; }
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Move Left"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Move Down"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Move Up"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Move Right"; }
    ];

    # ── 插件 ────────────────────────────────────────────────────
    plugins = {
      web-devicons.enable = true;

      lualine = {
        enable = true;
        settings.options = {
          theme = "catppuccin";
          globalstatus = true;
        };
      };

      alpha = {
        enable = true;
        theme = "dashboard";
      };

      nvim-tree = {
        enable = true;
        hijackCursor = true;
        syncRootWithCwd = true;
        view.width = 30;
        renderer.groupEmpty = true;
      };

      bufferline = {
        enable = true;
        settings.options.diagnostics = "nvim_lsp";
      };

      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
      };

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable    = true;
        };
      };

      lsp = {
        enable = true;
        servers = {
          lua_ls.enable  = true;
          nil_ls.enable  = true;
          ts_ls.enable   = true;
          pyright.enable = true;
          rust_analyzer = {
            enable         = true;
            installRustc   = false;
            installCargo   = false;
          };
        };
        keymaps = {
          diagnostic = {
            "<leader>d" = "open_float";
            "[d"        = "goto_prev";
            "]d"        = "goto_next";
          };
          lspBuf = {
            "gd"         = "definition";
            "gD"         = "declaration";
            "K"          = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
        };
      };

      fidget.enable = true;

      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<CR>"      = "cmp.mapping.confirm({ select = true })";
            "<C-Space>" = "cmp.mapping.complete()";
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require('luasnip')
                if cmp.visible() then cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                else fallback() end
              end, { "i", "s" })
            '';
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                local luasnip = require('luasnip')
                if cmp.visible() then cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                else fallback() end
              end, { "i", "s" })
            '';
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
      };

      luasnip = {
        enable = true;
        fromVscode = [{}];
      };
      friendly-snippets.enable = true;
      cmp_luasnip.enable       = true;
      cmp-nvim-lsp.enable      = true;
      cmp-buffer.enable        = true;
      cmp-path.enable          = true;

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix        = [ "alejandra" ];
            lua        = [ "stylua" ];
            python     = [ "black" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            css        = [ "prettierd" ];
            html       = [ "prettierd" ];
            json       = [ "prettierd" ];
          };
          format_on_save = {
            timeout_ms   = 500;
            lsp_fallback = true;
          };
        };
      };

      lint = {
        enable = true;
        lintersByFt = {
          python     = [ "flake8" ];
          javascript = [ "eslint_d" ];
          typescript = [ "eslint_d" ];
        };
      };

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text          = "▎";
          change.text       = "▎";
          delete.text       = "󰍵";
          topdelete.text    = "‾";
          changedelete.text = "~";
        };
      };
      lazygit.enable = true;

      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          float_opts.border = "curved";
        };
      };

      nix.enable = true;

      nvim-autopairs.enable   = true;
      comment.enable          = true;
      nvim-surround.enable    = true;
      which-key.enable        = true;
      indent-blankline.enable = true;
      noice.enable            = true;
      notify.enable           = true;
    };

    # ── 系統工具 ────────────────────────────────────────────────
    extraPackages = with pkgs; [
      alejandra
      stylua
      black
      prettierd
      ripgrep
      fd
      lazygit
      nodePackages.eslint_d
      python3Packages.flake8
    ];

    extraConfigLua = ''
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#b4befe", bold = true })
    '';
  };
}
