# 🏠 rqdmap's Chezmoi Dotfiles

一个功能丰富的跨平台dotfiles配置，支持Linux BSPWM桌面环境和macOS平铺布局。

## ✨ 特性

- 🖥️ **多平台支持**: Linux BSPWM桌面环境 & macOS平铺布局
- 🎨 **统一主题**: Gruvbox配色方案，一致的视觉体验
- 🚀 **高性能配置**: 优化的shell和工具配置
- 🔧 **模块化设计**: 按需加载配置，支持条件管理
- 📦 **外部依赖**: 自动管理git仓库和插件

## 🏗️ 支持的机器类型

| 类型 | 描述 | 窗口管理器 | 状态栏 |
|------|------|------------|--------|
| `home` | 个人Dell ArchLinux | BSPWM | Polybar |
| `work` | 工作用MacBook Pro | Yabai | SketchyBar |
| `vps` | 通用Debian VPS | - | - |
| `bspwm` | 通用Linux BSPWM桌面 | BSPWM | Polybar |
| `mac` | 通用macOS平铺布局 | Yabai | SketchyBar |

## 🚀 快速开始

### 1. 安装Chezmoi
```bash
# Arch Linux
pacman -S chezmoi

# macOS
brew install chezmoi

# 其他系统
sh -c "$(curl -fsSL https://git.io/chezmoi)"
```

### 2. 初始化配置

#### 方式1: 从GitHub克隆（推荐）
```bash
chezmoi init --branch chezmoi https://github.com/rqdmap/dotfiles.git
```

#### 方式2: 手动克隆（用于测试）
```bash
# 手动克隆到正确位置
git clone -b chezmoi https://github.com/rqdmap/dotfiles.git ~/.local/share/chezmoi

# 然后初始化
chezmoi init
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

# 编辑配置文件
chezmoi edit ~/.config/bspwm/bspwmrc

# 添加新文件
chezmoi add ~/.config/new-app/config
```

## 📁 配置概览

### Shell环境
- **Zsh**: 主shell，包含丰富的插件和别名
- **Starship**: 跨平台提示符

### 终端工具
- **Alacritty**: GPU加速终端模拟器
- **WezTerm**: 跨平台终端
- **Yazi**: 现代文件管理器

### 窗口管理
#### Linux BSPWM
- **BSPWM**: 平铺窗口管理器
- **Polybar**: 状态栏
- **Rofi**: 应用启动器和工具菜单
- **Picom**: 合成器
- **Sxhkd**: 快捷键守护进程

#### macOS
- **Yabai**: 平铺窗口管理器
- **SketchyBar**: 状态栏
- **Skhd**: 快捷键管理

### 开发工具
- **Neovim**: 通过外部git仓库管理
- **Git**: 全局配置
- **HTop**: 系统监控

## 🔧 配置管理

### 模板变量
配置使用以下模板变量：
- `machine_type`: 机器类型
- `bspwm`: 是否为BSPWM环境
- `macos`: 是否为MacOS环境

### 条件管理
通过`.chezmoiignore`实现条件配置：
```toml
{{ if not .bspwm }}
.config/bspwm
.config/polybar
{{ end }}

{{ if not .macos }}
.config/sketchybar
.yabairc
.skhdrc
{{ end }}
```

### 外部依赖
自动管理的git仓库：
- `.config/nvim`: Neovim配置
- `.zsh/plugins/zsh-autosuggestions`: Zsh自动建议
- `.zsh/plugins/zsh-syntax-highlighting`: Zsh语法高亮

## 🤝 贡献

欢迎提交Issue和Pull Request来改进配置！

## 📄 许可证

MIT License - 可自由使用和修改

---

**使用愉快！** 🎉
