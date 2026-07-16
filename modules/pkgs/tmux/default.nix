{ config, pkgs, ... }:
let
  ohMyTmuxSrc = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "af33f07134b76134acca9d01eacbdecca9c9cda6"; 
    hash = "sha256-nXm664l84YSwZeRM4Hsweqgz+OlpyfwXcgEdyNGhaGA="; 
  };
in
{
  home.packages = with pkgs; [
    tmux
    # TPM 某些插件（如 tmux-yank）可能依赖系统剪贴板工具，建议一并装上
    # xclip # Linux X11 环境
    # wl-clipboard # 如果你使用的是 Wayland 环境
  ];

  xdg.configFile = {
    "tmux/tmux.conf".source = "${ohMyTmuxSrc}/.tmux.conf";

    "tmux/tmux.conf.local".text = ''
      # ====================================================================
      # Oh My Tmux! 基础个性化设置
      # ====================================================================
      tmux_conf_copy_to_os_clipboard=true  # 自动同步系统剪贴板

      # ====================================================================
      # 👉 TPM (Tmux Plugin Manager) 插件集成区
      # ====================================================================
      
      # 1. 必须：声明并启用 TPM 自身
      set -g @plugin 'tmux-plugins/tpm'

      # 2. 模板：自动保存与恢复会话 (Resurrect & Continuum)
      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'tmux-plugins/tmux-continuum'
      # 插件参数配置
      set -g @resurrect-strategy-nvim 'session' # 恢复 nvim 会话
      set -g @continuum-restore 'on'            # 终端启动时自动恢复上一次会话

      # 3. 模板：更强大的全屏文本搜索与复制 (Tmux Fpp)
      # 允许你用快捷键进入文件路径选择模式
      set -g @plugin 'tmux-plugins/tmux-fpp'

      # 4. 模板：终端操作日志记录插件 (Tmux Logging)
      # 快捷键：Prefix + Shift + p 开启/关闭当前窗格的日志录制
      set -g @plugin 'tmux-plugins/tmux-logging'

      # 5. 模板：现代化第三方美化主题（如果你想覆盖 gpakosz 自带的主题）
      # set -g @plugin 'catppuccin/tmux'
      # set -g @catppuccin_flavour 'mocha' # latte, frappe, macchiato, mocha

      # ====================================================================
      # ⚠️ 关键：让 Oh My Tmux! 在启动时自动初始化 TPM
      # ====================================================================
      # gpakosz 框架规定：必须在配置的最后运行下述脚本
      run -b '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
