# /etc/nixos/modules/nushell.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  # ── Nushell ───────────────────────────────────────────
  programs.nushell = {
    enable = true;

    configFile.text = ''
      $env.config = {
        show_banner: false
        edit_mode: vi          # vi 鍵位，改 emacs 也可以

        cursor_shape: {
          vi_insert: line
          vi_normal: block
        }

        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"   # 模糊補全
        }

        history: {
          max_size: 10000
          sync_on_enter: true
          file_format: "sqlite"
        }

        table: {
          mode: rounded        # 表格樣式
          index_mode: always
        }
      }
    '';

    envFile.text = ''
      # zoxide 初始化
      zoxide init nushell | save -f ~/.zoxide.nu

      # Starship 初始化
      mkdir ~/.cache/starship
      starship init nu | save -f ~/.cache/starship/init.nu

    '';

    extraConfig = ''
      # 載入 zoxide
      source ~/.zoxide.nu

      # 載入 Starship prompt
      source ~/.cache/starship/init.nu

      # 縮寫
      alias ll   = eza -la --icons --git
      alias ls   = eza --icons
      alias lt   = eza --tree --icons -L 2
      alias cat  = bat
      alias grep = rg
      alias ps   = procs
      alias top  = btop
      alias v    = nvim
      alias rb   = sudo nixos-rebuild switch --flake /etc/nixos#nixos
    '';
  };

  # ── Starship prompt ───────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "[░▒▓](#a3aed2)"
        "[ 󰀄 $username](bg:#a3aed2 fg:#090c0c)"
        "[](fg:#a3aed2 bg:#769ff0)"
        "[$directory](bg:#769ff0 fg:#090c0c)"
        "[](fg:#769ff0 bg:#394260)"
        "[$git_branch$git_status](bg:#394260 fg:#769ff0)"
        "[](fg:#394260 bg:#212736)"
        "[$python$rust$nodejs$golang](bg:#212736 fg:#769ff0)"
        "[](fg:#212736)"
        "\n$character"
      ];

      username = {
        show_always = true;
        format = "[$user]($style)";
      };

      directory = {
        format = "[ $path]($style)";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = " ";
        format = "[ $symbol$branch]($style)";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      python.symbol = " ";
      rust.symbol = " ";
      nodejs.symbol = " ";
      golang.symbol = " ";
    };
  };

  # ── carapace（跨 shell 補全引擎）────────────────────
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  # ── 相依套件 ──────────────────────────────────────────
  home.packages = with pkgs; [
    zoxide # 智慧跳目錄
    eza # 現代 ls
    bat # 現代 cat
    ripgrep # 現代 grep
    procs # 現代 ps
    btop # 現代 top
    fd # 現代 find
    fzf # 模糊搜尋
  ];
}
