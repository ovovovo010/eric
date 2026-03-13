{
  pkgs,
  lib,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk; # Wayland 原生，Hyprland 下最順

    extraPackages = epkgs:
      with epkgs; [
        # ── Evil（Vim keybinding 核心） ─────────────────────────────────────────
        evil
        evil-collection # 讓 evil 接管幾乎所有 buffer
        evil-surround # cs"' ds( 等操作
        evil-commentary # gcc 注解
        evil-lion # gl= 對齊
        evil-exchange # gx 交換兩段文字
        evil-args # cia / daa 操作函式參數
        general # leader key 管理

        # ── UI / 外觀 ────────────────────────────────────────────────────────
        catppuccin-theme # 配合 Stylix
        doom-modeline # 好看的 modeline
        nerd-icons # 圖示（需要 nerd font）
        nerd-icons-dired
        nerd-icons-completion
        dashboard # 啟動畫面
        which-key # 按鍵提示
        rainbow-delimiters # 彩虹括號
        highlight-indent-guides # 縮排導引

        # ── 補全框架 ─────────────────────────────────────────────────────────
        vertico # 垂直補全 UI
        marginalia # 補全旁注
        orderless # 模糊搜尋
        consult # 強化搜尋指令（grep / buffer / imenu）
        embark # 對補全項目做操作
        embark-consult
        corfu # in-buffer 程式碼補全
        cape # corfu 補全來源擴充

        # ── LSP ──────────────────────────────────────────────────────────────
        lsp-mode
        lsp-ui # 側邊診斷、hover doc
        consult-lsp # consult 整合 LSP symbol 搜尋

        # ── 語法 / 語言 ──────────────────────────────────────────────────────
        nix-mode # Nix 語法
        nix-ts-mode # Nix tree-sitter
        treesit-auto # 自動切換 tree-sitter mode
        yaml-mode
        markdown-mode
        fish-mode

        # ── Git ──────────────────────────────────────────────────────────────
        magit # 最強 git UI
        magit-delta # magit diff 用 delta 渲染
        forge # GitHub PR / issue 整合
        diff-hl # gutter git diff

        # ── 檔案管理 ─────────────────────────────────────────────────────────
        dirvish # dired 強化版（封面 / 預覽）

        # ── 終端機 ───────────────────────────────────────────────────────────
        vterm # 真正的 terminal emulator
        multi-vterm

        # ── Org mode 瑞士刀 ──────────────────────────────────────────────────
        org
        org-modern # 好看的 org 渲染
        org-appear # 游標移過去才顯示 markup
        org-roam # 雙向連結筆記
        org-roam-ui # org-roam 的 web 視覺化圖
        org-download # 拖放圖片進 org
        org-superstar # 好看的標題符號
        toc-org # 自動產生目錄
        ox-pandoc # org 匯出 → 各種格式

        # ── 怪怪好玩的東西 ────────────────────────────────────────────────────

        eat # 另一個快速 terminal（比 vterm 新）
        nov # 讀 epub 電子書
        elcord # Discord Rich Presence（開 Emacs 讓朋友看到）
        speed-type # Emacs 裡練打字速度
        elfeed # RSS 閱讀器
        pomidor # 番茄鐘
        keycast # 顯示你正在按的鍵（直播用）
        explain-pause-mode # 找出讓 Emacs 卡住的元兇

        # ── 雜項實用 ─────────────────────────────────────────────────────────
        smartparens # 括號自動配對
        ws-butler # 自動清尾部空白
        undo-tree # 樹狀 undo 歷史
        avy # 跳轉到任意位置（像 Vim 的 easymotion）
        ace-window # 快速切換視窗
        helpful # 更好看的 help buffer
        flycheck # 即時語法檢查
      ];

    extraConfig = ''
      ;; ── 基本設定 ────────────────────────────────────────────────────────────
      (setq inhibit-startup-message t)
      (setq make-backup-files nil)
      (setq auto-save-default nil)
      (setq create-lockfiles nil)
      (setq native-comp-async-report-warnings-errors nil)

      ;; UI 清理
      (menu-bar-mode   -1)
      (tool-bar-mode   -1)
      (scroll-bar-mode -1)
      (tooltip-mode    -1)
      (set-fringe-mode 8)
      (global-hl-line-mode 1)
      (global-display-line-numbers-mode 1)
      (setq display-line-numbers-type 'relative)
      (column-number-mode 1)

      ;; ── 主題 ────────────────────────────────────────────────────────────────
      (load-theme 'catppuccin t)
      (setq catppuccin-flavor 'mocha)

      ;; ── 字型 ────────────────────────────────────────────────────────────────
      (set-face-attribute 'default nil
        :font "JetBrainsMono Nerd Font Mono"
        :height 140)

      ;; ── Evil ────────────────────────────────────────────────────────────────
      (require 'evil)
      (evil-mode 1)
      (require 'evil-collection)
      (evil-collection-init)
      (require 'evil-surround)
      (global-evil-surround-mode 1)
      (require 'evil-commentary)
      (evil-commentary-mode 1)

      ;; leader key
      (require 'general)
      (general-evil-setup t)
      (general-create-definer leader-def
        :states '(normal visual motion)
        :keymaps 'override
        :prefix "SPC")

      (leader-def
        "SPC" '(execute-extended-command :which-key "M-x")
        "f"   '(:ignore t :which-key "file")
        "ff"  '(find-file :which-key "find file")
        "fr"  '(consult-recent-file :which-key "recent files")
        "b"   '(:ignore t :which-key "buffer")
        "bb"  '(consult-buffer :which-key "switch buffer")
        "bk"  '(kill-this-buffer :which-key "kill buffer")
        "g"   '(:ignore t :which-key "git")
        "gg"  '(magit-status :which-key "magit")
        "s"   '(:ignore t :which-key "search")
        "ss"  '(consult-line :which-key "search line")
        "sg"  '(consult-grep :which-key "grep")
        "sr"  '(consult-ripgrep :which-key "ripgrep")
        "o"   '(:ignore t :which-key "org")
        "oa"  '(org-agenda :which-key "agenda")
        "oc"  '(org-capture :which-key "capture")
        "or"  '(org-roam-node-find :which-key "roam find")
        "t"   '(:ignore t :which-key "toggle")
        "tt"  '(vterm :which-key "terminal")
        "te"  '(eat :which-key "eat terminal")
        "w"   '(:ignore t :which-key "window")
        "wh"  '(windmove-left :which-key "←")
        "wj"  '(windmove-down :which-key "↓")
        "wk"  '(windmove-up :which-key "↑")
        "wl"  '(windmove-right :which-key "→")
        "ws"  '(split-window-below :which-key "split ↓")
        "wv"  '(split-window-right :which-key "split →")
        "wd"  '(delete-window :which-key "delete")
        "q"   '(:ignore t :which-key "quit")
        "qq"  '(save-buffers-kill-emacs :which-key "quit emacs"))

      ;; ── which-key ───────────────────────────────────────────────────────────
      (require 'which-key)
      (which-key-mode 1)
      (setq which-key-idle-delay 0.3)

      ;; ── 補全（Vertico + Orderless + Corfu） ────────────────────────────────
      (require 'vertico)
      (vertico-mode 1)
      (require 'marginalia)
      (marginalia-mode 1)
      (require 'orderless)
      (setq completion-styles '(orderless basic))
      (require 'corfu)
      (setq corfu-auto t corfu-auto-delay 0.1)
      (global-corfu-mode 1)

      ;; ── LSP ─────────────────────────────────────────────────────────────────
      (require 'lsp-mode)
      (setq lsp-keymap-prefix "C-c l")
      (setq lsp-idle-delay 0.3)
      (setq lsp-inlay-hint-enable t)
      (add-hook 'nix-mode-hook #'lsp-deferred)

      ;; ── doom-modeline ────────────────────────────────────────────────────────
      (require 'doom-modeline)
      (doom-modeline-mode 1)
      (setq doom-modeline-icon t)
      (setq doom-modeline-height 28)

      ;; ── rainbow-delimiters ───────────────────────────────────────────────────
      (require 'rainbow-delimiters)
      (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

      ;; ── Org ─────────────────────────────────────────────────────────────────
      (require 'org-modern)
      (global-org-modern-mode 1)
      (require 'org-appear)
      (add-hook 'org-mode-hook #'org-appear-mode)

      ;; ── dirvish ─────────────────────────────────────────────────────────────
      (require 'dirvish)
      (dirvish-override-dired-mode 1)

      ;; ── undo-tree ────────────────────────────────────────────────────────────
      (require 'undo-tree)
      (global-undo-tree-mode 1)
      (setq undo-tree-history-directory-alist
            '(("." . "~/.cache/emacs/undo-tree")))

      ;; ── avy ─────────────────────────────────────────────────────────────────
      (require 'avy)
      (evil-define-key 'normal 'global "gs" #'avy-goto-char-2)

      ;; ── magit ────────────────────────────────────────────────────────────────
      (require 'diff-hl)
      (global-diff-hl-mode 1)
      (add-hook 'magit-pre-refresh-hook  #'diff-hl-magit-pre-refresh)
      (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)

      ;; ── dashboard ────────────────────────────────────────────────────────────
      (require 'dashboard)
      (dashboard-setup-startup-hook)
      (setq dashboard-startup-banner 'logo)
      (setq dashboard-items '((recents   . 5)
                               (bookmarks . 5)
                               (projects  . 5)))

    '';
  };
}
