# home/nushell/nushell.nix
{pkgs, ...}: {
  programs.nushell = {
    enable = true;

    # ── 插件 ────────────────────────────────────────────────────
    plugins = with pkgs.nushellPlugins; [
      formats
      query
      highlight
      polars
      hcl
      semver
    ];

    configFile.text = ''
      $env.config = {
        show_banner:   false
        edit_mode:     vi

        cursor_shape: {
          vi_insert: line
          vi_normal: block
        }

        completions: {
          case_sensitive: false
          quick:          true
          partial:        true
          algorithm:      "fuzzy"
        }

        history: {
          max_size:      10000
          sync_on_enter: true
          file_format:   "sqlite"
        }

        table: {
          mode:       rounded
          index_mode: always
        }

        color_config: {
          separator:                   "#6c7086"
          leading_trailing_space_bg:   { attr: n }
          header:                      { fg: "#89b4fa" attr: b }
          empty:                       "#6c7086"
          bool:                        { fg: "#cba6f7" }
          int:                         { fg: "#fab387" }
          filesize:                    { fg: "#a6e3a1" }
          duration:                    { fg: "#f9e2af" }
          date:                        { fg: "#cba6f7" }
          range:                       { fg: "#f9e2af" }
          float:                       { fg: "#fab387" }
          string:                      { fg: "#a6e3a1" }
          nothing:                     { fg: "#6c7086" }
          binary:                      { fg: "#f38ba8" }
          cell-path:                   { fg: "#cdd6f4" }
          row_index:                   { fg: "#6c7086" attr: b }
          record:                      { fg: "#89dceb" }
          list:                        { fg: "#89dceb" }
          block:                       { fg: "#89b4fa" }
          hints:                       { fg: "#45475a" }
          search_result:               { fg: "#1e1e2e" bg: "#f38ba8" }
          shape_and:                   { fg: "#cba6f7" attr: b }
          shape_binary:                { fg: "#cba6f7" attr: b }
          shape_block:                 { fg: "#89b4fa" attr: b }
          shape_bool:                  { fg: "#89dceb" }
          shape_closure:               { fg: "#89dceb" attr: b }
          shape_custom:                { fg: "#a6e3a1" }
          shape_datetime:              { fg: "#89dceb" attr: b }
          shape_directory:             { fg: "#89dceb" }
          shape_external:              { fg: "#89dceb" }
          shape_external_resolved:     { fg: "#89b4fa" }
          shape_externalarg:           { fg: "#a6e3a1" }
          shape_filepath:              { fg: "#89dceb" }
          shape_flag:                  { fg: "#89b4fa" attr: b }
          shape_float:                 { fg: "#cba6f7" attr: b }
          shape_garbage:               { fg: "#1e1e2e" bg: "#f38ba8" attr: b }
          shape_glob_interpolation:    { fg: "#89dceb" attr: b }
          shape_globpattern:           { fg: "#89dceb" attr: b }
          shape_int:                   { fg: "#cba6f7" attr: b }
          shape_internalcall:          { fg: "#89dceb" attr: b }
          shape_keyword:               { fg: "#cba6f7" attr: b }
          shape_list:                  { fg: "#89dceb" attr: b }
          shape_literal:               { fg: "#89b4fa" }
          shape_match_pattern:         { fg: "#a6e3a1" }
          shape_matching_brackets:     { attr: u }
          shape_nothing:               { fg: "#89dceb" }
          shape_operator:              { fg: "#f9e2af" }
          shape_or:                    { fg: "#cba6f7" attr: b }
          shape_pipe:                  { fg: "#cba6f7" attr: b }
          shape_range:                 { fg: "#f9e2af" attr: b }
          shape_raw_string:            { fg: "#cdd6f4" attr: b }
          shape_record:                { fg: "#89dceb" attr: b }
          shape_redirection:           { fg: "#cba6f7" attr: b }
          shape_semi:                  { fg: "#cba6f7" attr: b }
          shape_signature:             { fg: "#a6e3a1" attr: b }
          shape_string:                { fg: "#a6e3a1" }
          shape_string_interpolation:  { fg: "#89dceb" attr: b }
          shape_table:                 { fg: "#89b4fa" attr: b }
          shape_variable:              { fg: "#cba6f7" }
          shape_vardecl:               { fg: "#cba6f7" attr: u }
          shape_vardecl_global:        { fg: "#f38ba8" attr: b }
        }

        menus: [
          {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
              layout: columnar
              columns: 4
              col_width: 20
              col_padding: 2
            }
            style: {
              text:                { fg: "#cdd6f4" }
              selected_text:       { fg: "#1e1e2e" bg: "#89b4fa" }
              description_text:    { fg: "#6c7086" }
              match_text:          { fg: "#f9e2af" attr: b }
              selected_match_text: { fg: "#1e1e2e" bg: "#89b4fa" attr: b }
            }
          }
          {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: {
              layout: list
              page_size: 10
            }
            style: {
              text:             { fg: "#cdd6f4" }
              selected_text:    { fg: "#1e1e2e" bg: "#cba6f7" }
              description_text: { fg: "#6c7086" }
            }
          }
        ]

        keybindings: [
          {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [emacs vi_insert vi_normal]
            event: { send: menu name: history_menu }
          }
          {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_insert]
            event: { send: menu name: completion_menu }
          }
        ]
      }
    '';

    envFile.text = ''
      $env.EDITOR = "nvim"
      $env.VISUAL = "nvim"
      $env.PATH   = ($env.PATH | prepend $"($env.HOME)/.local/bin")

      zoxide init nushell | save -f ~/.zoxide.nu
      mkdir ~/.cache/starship
      starship init nu | save -f ~/.cache/starship/init.nu
      atuin init nu | save -f ~/.atuin.nu
    '';

    extraConfig = ''
      source ~/.zoxide.nu
      source ~/.cache/starship/init.nu
      source ~/.atuin.nu

      alias ll   = eza -la --icons --git --group-directories-first
      alias ls   = eza --icons --group-directories-first
      alias la   = eza -a --icons --group-directories-first
      alias lt   = eza --tree --icons -L 2
      alias lt3  = eza --tree --icons -L 3
      alias cat  = bat --style=numbers,changes
      alias grep = rg
      alias ps   = procs
      alias top  = btop
      alias df   = duf
      alias du   = dust
      alias v    = nvim
      alias vi   = nvim
      alias vim  = nvim
      alias z    = zoxide
      alias cd   = zoxide
      alias sw   = nh os switch /home/eric/nixos-config
      alias up   = nix flake update /home/eric/nixos-config
      alias nr   = nix repl "<nixpkgs>"
      alias g    = git
      alias ga   = git add
      alias gp   = git push
      alias gl   = git log --oneline --graph
      alias gs   = git status
      alias lg   = lazygit

      def mkcd [dir: string] {
        mkdir $dir
        cd $dir
      }

      def top-cmds [] {
        history | get command | str replace -r ' .*' "" | sort | uniq -c | sort -r | first 15
      }
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
