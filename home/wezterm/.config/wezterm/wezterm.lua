local wezterm = require('wezterm')
local config = wezterm.config_builder()

-- 字体配置
config.font = wezterm.font_with_fallback({
    {
        family = 'Iosevka Nerd Font',
        harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
    },
    'Source Han Sans CN',
    'Noto Color Emoji',
})
config.font_size = 13
config.unicode_version = 14
config.warn_about_missing_glyphs = false

-- 自动使用暗色色调
config.bold_brightens_ansi_colors = false
config.color_scheme = 'GruvboxDark'

-- 窗口配置
config.window_padding = {
  left = 20,
  right = 20,
  top = 20,
  bottom = 20,
}
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"


-- 键盘快捷键
config.keys = {
  {
    key = '1',
    mods = 'CTRL',
    action = wezterm.action.ScrollByLine(-1),
  },
  {
    key = '2',
    mods = 'CTRL',
    action = wezterm.action.ScrollByLine(1),
  },
  -- 正确发送 Ctrl + / 信号
  {
    key = '/',
    mods = 'CTRL',
    action = wezterm.action.SendString(string.char(0x1f)),
  },
}

return config
