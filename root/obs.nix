# /root/obs.nix
# NixOS 系统级 OBS Studio 配置模块
# 参考: NixOS Wiki - OBS Studio [citation:1]
# 适用 NixOS 版本: 24.11, 25.05+

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.obs-studio;  # 使用 services 命名空间，避免与 programs 冲突
in
{
  ###########################
  ### 选项定义 (Options)  ###
  ###########################
  options.services.obs-studio = {
    enable = mkEnableOption "系统级 OBS Studio 支持（虚拟摄像头等）";

    enableVirtualCamera = mkEnableOption ''
      OBS 虚拟摄像头支持
      自动配置 v4l2loopback 内核模块和 polkit
    '';

    # 手动配置 v4l2loopback 选项（当需要自定义时使用）
    v4l2loopback = {
      enable = mkEnableOption "手动配置 v4l2loopback 内核模块";
      
      devices = mkOption {
        type = types.int;
        default = 1;
        description = "要创建的虚拟摄像头设备数量";
      };
      
      videoNumbers = mkOption {
        type = types.listOf types.int;
        default = [ 1 ];
        description = "视频设备编号列表（如 [1 2] 对应 /dev/video1, /dev/video2）";
      };
      
      cardLabels = mkOption {
        type = types.listOf types.str;
        default = [ "OBS Virtual Camera" ];
        description = "虚拟摄像头的标签名称列表";
      };
      
      exclusiveCaps = mkOption {
        type = types.bool;
        default = true;
        description = "是否设置 exclusive_caps=1 以提高兼容性";
      };
    };

    # 系统级插件安装（可选，Home Manager 已经处理插件时可不启用）
    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression ''
        with pkgs.obs-studio-plugins; [
          obs-backgroundremoval
          wlrobs
        ]
      '';
      description = "系统级安装的 OBS 插件（用于所有用户）";
    };
  };

  ###########################
  ### 配置实现 (Config)   ###
  ###########################
  config = mkIf cfg.enable {
    # 1. 处理虚拟摄像头配置（自动模式）
    # 当 enableVirtualCamera = true 时，使用 NixOS 内置模块
    programs.obs-studio = mkIf cfg.enableVirtualCamera {
      enableVirtualCamera = true;
    };

    # 2. 处理手动 v4l2loopback 配置（当用户需要自定义时）
    boot = mkIf (cfg.v4l2loopback.enable) {
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      kernelModules = [ "v4l2loopback" ];
      
      # 构建 v4l2loopback 模块参数
      extraModprobeConfig = let
        devices = cfg.v4l2loopback.devices;
        video_nr = concatStringsSep "," (map toString cfg.v4l2loopback.videoNumbers);
        card_label = concatStringsSep "," cfg.v4l2loopback.cardLabels;
        exclusive_caps = if cfg.v4l2loopback.exclusiveCaps then "1" else "0";
      in ''
        options v4l2loopback devices=${toString devices} video_nr=${video_nr} card_label="${card_label}" exclusive_caps=${exclusive_caps}
      '';
    };

    # 3. 确保 polkit 启用（虚拟摄像头需要）
    security.polkit.enable = mkIf (cfg.enableVirtualCamera || cfg.v4l2loopback.enable) (mkDefault true);

    # 4. 可选：系统级安装 OBS（带插件包装）
    # 注意：如果 Home Manager 已经安装了带插件的 OBS，这里建议不要重复安装
    # 此选项仅用于希望所有系统用户都能使用带插件的 OBS 的情况
    environment.systemPackages = mkIf (cfg.plugins != [ ]) [
      (pkgs.wrapOBS {
        plugins = cfg.plugins;
      })
    ];

    # 5. 提醒信息（通过激活脚本输出，NixOS 可以使用 warnings）
    warnings = optional (cfg.enableVirtualCamera && cfg.v4l2loopback.enable) ''
      警告: 你同时启用了 services.obs-studio.enableVirtualCamera 和 services.obs-studio.v4l2loopback.enable。
      建议只使用其中一个，避免配置冲突。推荐使用 enableVirtualCamera（自动模式）。
    '';
  };
}
