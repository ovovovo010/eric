# ~/nixos-config/sops.nix
{
  config,
  inputs,
  ...
}: {
  sops = {
    # 這是你加密後的資料檔案路徑（需先用 sops 指令建立此檔案）
    defaultSopsFile = ./secrets/secrets.yaml;

    # 是否自動將密鑰檔案注入到 /run/secrets/
    # 這樣程式就可以透過路徑讀取，而不會出現在 Nix Store 中
    validateSopsFiles = false;

    # 使用本機的 SSH ed25519 金鑰作為解密密鑰 [cite: 5, 6]
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    # 定義要產生的密鑰檔案
    secrets = {
      # 範例：定義一個名為 "my-password" 的密鑰
      # 它會出現在 /run/secrets/my-password
      "user-password" = {
        neededForUsers = true; # 如果是用於使用者登入密碼，設為 true
      };
      "wifi-password" = {};
    };
  };
}
