{ pkgs, config, lib, ... }:

{
  # 啟用 Podman（distrobox 的後端）
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;       # 讓 docker 指令也能用
    defaultNetwork.settings.dns_enabled = true;
  };

  # 讓一般使用者可以用 rootless podman
  security.unprivilegedUsernsClone = true;

  # subuid / subgid 配置已統一在 root/users/users.nix
}
