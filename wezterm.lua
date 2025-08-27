local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- config.font_size = 12
-- config.color_scheme = 'AdventureTime'
config.font = wezterm.font 'Hack'
config.detect_password_input = false
-- don't need a tab bar if xfce shows 1/2 in the title bar
config.enable_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true

config.mouse_bindings = {
  -- {
  --   event = { Up = { streak = 1, button = "Left" } },
  --   mods = "NONE",
  --   action = wezterm.action.OpenLinkAtMouseCursor,
  -- },
  { -- support X11 selection
    event = { Up = { streak = 1, button = 'Left'} },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection 'PrimarySelection',
  },
}

return config -- back to wezterm
