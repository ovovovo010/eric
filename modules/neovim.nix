{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # 1. 直接在這裡列出你要的插件，Nix 會自動處理路徑
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim    # 主題
      nvim-web-devicons  # 圖標
      lualine-nvim       # 狀態列
      telescope-nvim     # 搜尋
      nvim-treesitter.withAllGrammars # 語法高亮
      alpha-nvim         # 啟動畫面
      # Alejandra 格式化通常是系統層級，不用放這
    ];

    # 2. 把你的設定直接寫成 Lua
    extraLuaConfig = ''
      -- 基礎設定
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.shiftwidth = 2
      vim.opt.cursorline = true
      vim.g.mapleader = " "

      -- 啟用主題 (Stylix 通常會幫你處理，若沒顏色再解開這行)
      -- vim.cmd.colorscheme "catppuccin-latte"

      -- 簡單啟動插件
      require('lualine').setup()
      require('alpha').setup(require('alpha.themes.dashboard').config)
      require('telescope').setup()
      
      -- 你的自定義高亮
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#b4befe", bold = true })
    '';
  };
}

