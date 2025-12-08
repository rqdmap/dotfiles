# 🏠 rqdmap's Chezmoi Dotfiles

一个功能丰富的跨平台 dotfiles 配置，支持 Linux BSPWM 桌面环境和 macOS 平铺布局。

## ✨ 特性

- 🖥️ **多平台支持**: Linux BSPWM 桌面环境 & macOS 平铺布局
- 🎨 **统一主题**: Gruvbox 配色方案，一致的视觉体验
- 🚀 **高性能配置**: 优化的 shell 和工具配置
- 🔧 **模块化设计**: 按需加载配置，支持条件管理
- 📦 **外部依赖**: 自动管理 git 仓库和插件

## 🏗️ 支持的机器类型

| 类型 | 描述 | 窗口管理器 | 状态栏 |
|------|------|------------|--------|
| `home` | 个人 Dell ArchLinux | BSPWM | Polybar |
| `work` | 工作用 MacBook Pro | Yabai | SketchyBar |
| `vps` | 通用 Debian VPS | - | - |
| `bspwm` | 通用 Linux BSPWM 桌面 | BSPWM | Polybar |
| `mac` | 通用 macOS 平铺布局 | Yabai | SketchyBar |

## 🚀 快速开始

### 1. 安装 Chezmoi
```bash
# Arch Linux
pacman -S chezmoi

# macOS
brew install chezmoi

# 其他系统
sh -c "$(curl -fsSL https://git.io/chezmoi)"
```

### 2. 初始化配置

#### 方式 1: 从 GitHub 克隆（推荐）
```bash
chezmoi init --branch chezmoi https://github.com/rqdmap/dotfiles.git
```

#### 方式 2: 手动克隆（用于测试）
```bash
# 手动克隆到正确位置
git clone -b chezmoi https://github.com/rqdmap/dotfiles.git ~/.local/share/chezmoi
```

#### 首次运行
选择机器类型（首次运行时会提示）：
```bash
chezmoi init
```

### 3. 管理配置
```bash
# 查看状态
chezmoi status

# 应用所有更改
chezmoi apply

# 查看将要应用的更改
chezmoi diff

# 编辑配置文件
chezmoi edit ~/.config/bspwm/bspwmrc

# 添加新文件
chezmoi add ~/.config/new-app/config

# 更新外部依赖 (如 Neovim 配置)
chezmoi update
```

## 📁 配置概览

### Shell 环境
- **Zsh**: 主 shell，包含丰富的插件和别名
- **Starship**: 跨平台提示符

### 终端工具
- **Alacritty**: GPU 加速终端模拟器（主要）
- **WezTerm**: 跨平台终端（macOS）
- **Yazi**: 现代文件管理器
- **Joshuto**: 轻量级文件管理器
- **Tmux**: 终端多路复用器

### 窗口管理
#### Linux BSPWM
- **BSPWM**: 平铺窗口管理器
- **Polybar**: 状态栏
- **Rofi**: 应用启动器和工具菜单
- **Picom**: 合成器
- **Sxhkd**: 快捷键守护进程
- **Dunst**: 通知服务
- **xss-lock**: 屏幕锁定

#### macOS
- **Yabai**: 平铺窗口管理器
- **SketchyBar**: 状态栏
- **Skhd**: 快捷键管理

### 开发工具
- **Neovim**: 通过外部 git 仓库管理
- **Git**: 全局配置
- **HTop**: 系统监控
- **Python 管理**: uv

### 其他工具
- **Zathura**: PDF 阅读器（Linux）
- **Clash**: 代理工具
- **SSH 隧道**: systemd 服务管理

## 🏗️ 目录结构

```
~/.local/share/chezmoi/
├── dot_config/           # ~/.config/ 下的配置
│   ├── alacritty/       # 终端配置
│   ├── bspwm/           # BSPWM 窗口管理器
│   ├── polybar/         # 状态栏配置
│   ├── rofi/            # 应用启动器
│   ├── sxhkd/           # 快捷键配置
│   ├── joshuto/         # 文件管理器
│   ├── yazi/            # 另一个文件管理器
│   ├── sketchybar/      # macOS 状态栏
│   └── ...              # 其他应用配置
├── dot_zsh/             # ~/.zsh/ 目录
│   ├── dot_zshrc.tmpl   # zsh 配置模板
│   ├── plugins.zsh      # zsh 插件
│   └── completions/     # 补全脚本
├── .chezmoi.toml.tmpl   # 机器类型选择和数据定义
├── .chezmoiexternal.toml # 外部依赖管理
├── .chezmoiignore       # 条件化忽略规则
└── symlink_dot_zshrc    # zshrc 符号链接
```

## 🔧 配置管理

### 模板变量
配置使用以下模板变量：
- `machine_type`: 机器类型
- `bspwm`: 是否为 BSPWM 环境 (自动生成)
- `macos`: 是否为 MacOS 环境 (自动生成)
- `generic`: 是否是通用配置 (自动生成)

### 条件管理
通过 `.chezmoiignore` 实现条件配置：
```toml
# BSPWM-Specific files
{{ if not .bspwm }}
.config/bspwm
.config/polybar
{{ end }}

# macOS-Specific files
{{ if not .macos }}
.config/sketchybar
.yabairc
.skhdrc
{{ end }}
```

### 外部依赖
自动管理的外部 git 仓库：
- `.config/nvim`: Neovim 配置
- `.zsh/plugins/zsh-autosuggestions`: Zsh 自动建议
- `.zsh/plugins/zsh-syntax-highlighting`: Zsh 语法高亮

## 📝 使用示例

### 添加新配置
```bash
# 将现有文件添加到 chezmoi 管理
chezmoi add ~/.gitconfig

# 创建新的模板文件
chezmoi edit --create ~/.newconfig.tmpl
```

### 条件化配置示例
在模板文件中使用条件逻辑：
```tmpl
{{ if .macos }}
# macOS specific configuration
export PATH="/opt/homebrew/bin:$PATH"
{{ else }}
# Linux specific configuration
export PATH="/usr/local/bin:$PATH"
{{ end }}
```

## 🤝 贡献与维护

1. 在源目录 (`~/.local/share/chezmoi`) 中修改配置
2. 使用 `chezmoi apply` 测试更改
3. 提交到 git 仓库进行版本控制
4. 使用 `chezmoi update` 同步到其他机器

## 📚 参考资源

- [Chezmoi 官方文档](https://chezmoi.io/)
- [BSPWM 配置指南](https://github.com/baskerville/bspwm)
- [Starship 主题配置](https://starship.rs/)

## 📄 许可证

MIT License - 可自由使用和修改

---

**使用愉快！** 🎉
