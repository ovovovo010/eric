# home/nushell/starship.nix
{ lib, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "\n$character"
      ];

      right_format = "$time";

      add_newline     = false;
      command_timeout = 500;

      directory = {
        format            = "[ $path ]($style)";
        style             = "bg:#89b4fa fg:#1e1e2e bold";
        truncation_length = 1;
        truncate_to_repo  = false;
      };

      time = {
        disabled        = false;
        format          = "[$time]($style)";
        style           = "fg:#6c7086";
        time_format     = "%H:%M:%S";
        utc_time_offset = "+8";
      };

      character = {
        success_symbol = "[❯](bold fg:#a6e3a1)";
        error_symbol   = "[❯](bold fg:#f38ba8)";
        vimcmd_symbol  = "[❮](bold fg:#cba6f7)";
      };

      git_branch.disabled  = true;
      git_status.disabled  = true;
      username.disabled    = true;
      hostname.disabled    = true;
      package.disabled     = true;
      nix_shell.disabled   = true;
      python.disabled      = true;
      rust.disabled        = true;
      nodejs.disabled      = true;
      golang.disabled      = true;
      zig.disabled         = true;
      cmd_duration.disabled = true;
    };
  };
}
