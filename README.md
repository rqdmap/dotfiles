# 🏠 rqdmap's Chezmoi Dotfiles

一个功能丰富的跨平台 dotfiles 配置，支持多种 Linux 和 macOS 环境，从桌面到服务器。

## ✨ 特性

- 🖥️ **多平台支持**: ArchLinux / Debian / macOS，桌面与服务器
- 🎨 **统一主题**: Gruvbox 配色方案，一致的视觉体验
- 🪟 **平铺窗口管理**: Linux 使用 BSPWM，macOS 使用 AeroSpace
- 🚀 **高性能配置**: 优化的 shell 和工具配置
- 🔧 **模块化设计**: 多维度条件化配置，按需加载
- 📦 **外部依赖**: 自动管理 git 仓库和插件

## 🏗️ 支持的机器类型

### Personal Machines（个人机器）
| 预设 | 系统 | 类型 | 窗口管理 | 说明 |
|------|------|------|----------|------|
| `home` | ArchLinux | Desktop | Tiling WM | 个人桌面工作站 |
| `work` | macOS| Desktop | Tiling WM | 个人工作笔记本 |
| `macPie` | macOS| Server | Headless | 个人 Mac 服务器 |

### Generic Machines（通用机器）
| 预设 | 系统 | 类型 | 窗口管理 | 说明 |
|------|------|------|----------|------|
| `vps` | Debian | Server | Headless | 通用 VPS 服务器 |
| `linux` | ArchLinux | Desktop | Tiling WM | 通用 Linux 桌面 |
| `mac` | macOS | Desktop | Tiling WM | 通用 Mac 桌面 |

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
- **Alacritty**: GPU 加速终端模拟器
- **WezTerm**: 跨平台终端, 复杂渲染能力更强
- **Yazi**: 现代文件管理器
- **Joshuto**: 轻量级文件管理器
- **Tmux**: 终端多路复用器

### 窗口管理
#### Linux 平铺桌面
- **平铺 WM**: BSPWM
- **Polybar**: 状态栏
- **Rofi**: 应用启动器和工具菜单
- **Picom**: 合成器
- **Sxhkd**: 快捷键守护进程
- **Dunst**: 通知服务
- **xss-lock**: 屏幕锁定

#### macOS 平铺桌面
- **平铺 WM**: 由 `macos_tiling_backend` 选择 AeroSpace 或 Yabai
- **默认后端**: AeroSpace，Yabai 保留为 dormant fallback
- **SketchyBar**: 状态栏
- **skhd**: 应用启动快捷键
- **Karabiner-Elements**: 窗口快捷键事件总线

### 开发工具
- **Neovim**: 通过外部 git 仓库管理配置
- **Git**: 全局配置
- **HTop**: 系统监控
- **Python 管理**: uv

### 其他工具
- **Zathura**: PDF 阅读器（Linux）
- **SSH 隧道**: systemd 模板服务管理, 暴露内网服务

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

### 配置维度

配置按四个核心维度组织：

1. **Profile（配置档案）**
   - `personal` - 个人使用，包含私人工具和配置
   - `generic` - 通用配置，适合公共或临时机器

2. **OS（操作系统）**
   - `arch` - Arch Linux
   - `debian` - Debian/Ubuntu
   - `macos` - macOS

3. **Interface（界面类型）**
   - `gui` - 图形界面（带窗口管理器）
   - `headless` - 纯命令行服务器

4. **Window Manager（窗口管理器）**
   - `tiling` - 平铺窗口管理器（Linux 用 BSPWM，macOS 由 backend 选择）
   - `none` - 无窗口管理器

### 模板变量

所有可用的模板变量：

**主要属性：**
- `.profile` - 配置档案 (personal/generic)
- `.os` - 操作系统 (arch/debian/macos)
- `.interface` - 界面类型 (gui/headless)
- `.wm` - 窗口管理器 (tiling/none)
- `.macos_tiling_backend` - macOS tiling 后端 (aerospace/yabai/none)

**便捷标志：**
- `.is_personal` / `.is_generic` - Profile 判断
- `.is_arch` / `.is_debian` / `.is_macos` - OS 判断
- `.is_linux` - 任意 Linux
- `.is_gui` / `.is_headless` - 界面判断
- `.has_tiling_wm` - 是否使用平铺窗口管理器

**查看当前机器的所有变量：**
```bash
chezmoi data
```

### 条件管理

#### 在 `.chezmoiignore` 中排除文件：
```toml
# Linux 平铺 WM 配置（非 Linux 平铺环境排除）
{{ if not (and .has_tiling_wm .is_linux) }}
.config/bspwm
.config/polybar
{{ end }}

# macOS 平铺 WM 配置（非 macOS 平铺环境排除）
{{ if not (and .has_tiling_wm .is_macos) }}
.config/aerospace
.config/sketchybar
.config/skhd
.skhdrc
{{ end }}

# 无头服务器排除所有 GUI 配置
{{ if .is_headless }}
.config/bspwm
.config/polybar
.config/aerospace
.config/sketchybar
.config/skhd
.skhdrc
{{ end }}
```

#### 在模板文件中使用条件：
```bash
# 单条件
{{ if .is_macos }}
export PATH="/opt/homebrew/bin:$PATH"
{{ end }}

# 平铺窗口管理器通用配置
{{ if .has_tiling_wm }}
# 适用于任何平铺 WM 的配置
{{ end }}

# 多条件
{{ if and .is_gui .is_linux }}
# Linux GUI 专属配置
{{ end }}

# Profile 判断
{{ if .is_personal }}
alias blog="/usr/local/bin/blog"
{{ end }}
```

### 外部依赖
自动管理的外部 git 仓库：
- `.config/nvim`: Neovim 配置
- `.zsh/plugins/zsh-autosuggestions`: Zsh 自动建议
- `.zsh/plugins/zsh-syntax-highlighting`: Zsh 语法高亮

### 机器预设配置表

| 预设   | Profile  | OS     | Interface | WM     | 使用场景 |
|--------|----------|--------|-----------|--------|----------|
| home   | personal | arch   | gui       | tiling | 个人 Arch 桌面 |
| work   | personal | macos  | gui       | tiling | 个人 Mac 工作机 |
| macpie | personal | macos  | headless  | none   | 个人 Mac 服务器 |
| vps    | generic  | debian | headless  | none   | 通用 Debian 服务器 |
| linux  | generic  | arch   | gui       | tiling | 通用 Linux 桌面 |
| mac    | generic  | macos  | gui       | tiling | 通用 Mac 桌面 |

### 文件组织原则

- **核心配置**（所有机器）：zsh, tmux, git, starship, yazi
- **平铺 WM 配置**（通过 .chezmoiignore 按系统排除）：
  - Linux: bspwm, polybar, rofi, picom, sxhkd
  - macOS: AeroSpace 或 Yabai, SketchyBar, Karabiner-Elements, skhd
- **系统特定**：systemd（Linux），brew 相关（macOS）
- **个人工具**（generic 机器排除）：个人脚本如 blog

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
```bash
{{ if .is_macos }}
# macOS specific configuration
export PATH="/opt/homebrew/bin:$PATH"
{{ else }}
# Linux specific configuration
export PATH="/usr/local/bin:$PATH"
{{ end }}

{{ if .has_tiling_wm }}
# 通用平铺 WM 配置
export TILING_WM=true
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
