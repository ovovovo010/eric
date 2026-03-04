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

  # subuid / subgid（rootless container 必須）
  users.users.eric = {
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };
}
