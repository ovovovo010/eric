-- ══════════════════════════════════════════════════════════════
-- rc.lua  –  Catppuccin Mocha + bling
-- ══════════════════════════════════════════════════════════════

pcall(require, "luarocks.loader")

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local bling = require("bling")

require("awful.autofocus")
require("awful.hotkeys_popup.keys")

-- ── 錯誤處理 ─────────────────────────────────────────────────
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = startup and "Startup Error" or "Runtime Error",
		message = message,
	})
end)

-- ── Catppuccin Mocha 配色 ─────────────────────────────────────
local colors = {
	base = "#1e1e2e",
	mantle = "#181825",
	crust = "#11111b",
	surface0 = "#313244",
	surface1 = "#45475a",
	surface2 = "#585b70",
	overlay0 = "#6c7086",
	overlay1 = "#7f849c",
	text = "#cdd6f4",
	lavender = "#b4befe",
	blue = "#89b4fa",
	sapphire = "#74c7ec",
	sky = "#89dceb",
	teal = "#94e2d5",
	green = "#a6e3a1",
	yellow = "#f9e2af",
	peach = "#fab387",
	maroon = "#eba0ac",
	red = "#f38ba8",
	mauve = "#cba6f7",
	pink = "#f5c2e7",
	flamingo = "#f2cdcd",
	rosewater = "#f5e0dc",
}

-- ── 主題 ──────────────────────────────────────────────────────
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

beautiful.font = "JetBrainsMono Nerd Font 10"
beautiful.bg_normal = colors.base
beautiful.bg_focus = colors.surface0
beautiful.bg_urgent = colors.red
beautiful.bg_minimize = colors.mantle
beautiful.bg_systray = colors.base
beautiful.fg_normal = colors.text
beautiful.fg_focus = colors.lavender
beautiful.fg_urgent = colors.base
beautiful.fg_minimize = colors.overlay0
beautiful.border_width = 2
beautiful.border_normal = colors.surface0
beautiful.border_focus = colors.lavender
beautiful.border_marked = colors.red
beautiful.useless_gap = 8
beautiful.gap_single_client = true

-- bling 標籤預覽
beautiful.tag_preview_widget_border_radius = 12
beautiful.tag_preview_client_border_radius = 8
beautiful.tag_preview_client_opacity = 0.8
beautiful.tag_preview_client_bg = colors.surface0
beautiful.tag_preview_client_border_color = colors.lavender
beautiful.tag_preview_widget_bg = colors.base
beautiful.tag_preview_widget_border_color = colors.lavender

-- ── 變數 ──────────────────────────────────────────────────────
local terminal = "kitty"
local filemanager = "kitty -e yazi"
local launcher = "rofi -show drun"
local editor = "nvim"
local modkey = "Mod4" -- Super

-- ── bling 插件 ────────────────────────────────────────────────
bling.widget.tag_preview.enable({
	show_client_content = true,
	x = 10,
	y = 10,
	scale = 0.25,
	honor_padding = false,
	honor_workarea = false,
})

bling.module.flash_focus.enable()

-- ── Layouts ───────────────────────────────────────────────────
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts({
		awful.layout.suit.tile,
		awful.layout.suit.tile.left,
		awful.layout.suit.floating,
		awful.layout.suit.max,
		bling.layout.mstab,
		bling.layout.centered,
	})
end)

-- ── Tags ──────────────────────────────────────────────────────
screen.connect_signal("request::desktop_decoration", function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	-- Wibar
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		height = 36,
		bg = colors.base .. "cc",
		fg = colors.text,
	})

	-- taglist
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
	})

	-- tasklist
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button({}, 1, function(c)
				c:activate({ context = "tasklist", action = "toggle_minimization" })
			end),
		},
	})

	-- clock
	local clock = wibox.widget.textclock('<span color="' .. colors.lavender .. '"> %H:%M</span>')

	s.mywibox.widget = {
		layout = wibox.layout.align.horizontal,
		{ -- 左
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
		},
		s.mytasklist, -- 中
		{ -- 右
			layout = wibox.layout.fixed.horizontal,
			wibox.widget.systray(),
			clock,
		},
	}
end)

-- ── Mouse bindings ────────────────────────────────────────────
awful.mouse.append_global_mousebindings({
	awful.button({}, 3, function()
		awful.spawn(launcher)
	end),
	awful.button({}, 4, awful.tag.viewprev),
	awful.button({}, 5, awful.tag.viewnext),
})

-- ── Keybindings ───────────────────────────────────────────────
awful.keyboard.append_global_keybindings({
	-- 程式（對照 Hyprland）
	awful.key({ modkey }, "q", function()
		awful.spawn(terminal)
	end, { description = "terminal", group = "launcher" }),
	awful.key({ modkey }, "e", function()
		awful.spawn(filemanager)
	end, { description = "file manager", group = "launcher" }),
	awful.key({ modkey }, "r", function()
		awful.spawn(launcher)
	end, { description = "launcher", group = "launcher" }),
	awful.key({ modkey }, "l", function()
		awful.spawn("xscreensaver-command -lock")
	end, { description = "lock", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "e", function()
		awful.spawn("wlogout")
	end, { description = "logout", group = "launcher" }),

	-- 截圖
	awful.key({}, "Print", function()
		awful.spawn("scrot -e 'xclip -selection clipboard -t image/png < $f'")
	end, { description = "screenshot", group = "screenshot" }),
	awful.key({ modkey }, "Print", function()
		awful.spawn("scrot ~/Pictures/Screenshots/%Y%m%d_%H%M%S.png")
	end, { description = "screenshot to file", group = "screenshot" }),
	awful.key({ modkey, "Shift" }, "s", function()
		awful.spawn("scrot -s -e 'xclip -selection clipboard -t image/png < $f'")
	end, { description = "screenshot region", group = "screenshot" }),

	-- 音量
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
	end),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
	end),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
	end),

	-- WM
	awful.key({ modkey }, "c", function()
		if client.focus then
			client.focus:kill()
		end
	end, { description = "close", group = "client" }),
	awful.key({ modkey }, "v", function()
		if client.focus then
			client.focus.floating = not client.focus.floating
		end
	end, { description = "toggle floating", group = "client" }),
	awful.key({ modkey }, "j", function()
		awful.layout.inc(1)
	end, { description = "next layout", group = "layout" }),

	-- 焦點移動（對照 Hyprland 方向鍵）
	awful.key({ modkey }, "Left", function()
		awful.client.focus.bydirection("left")
	end),
	awful.key({ modkey }, "Right", function()
		awful.client.focus.bydirection("right")
	end),
	awful.key({ modkey }, "Up", function()
		awful.client.focus.bydirection("up")
	end),
	awful.key({ modkey }, "Down", function()
		awful.client.focus.bydirection("down")
	end),

	-- 視窗移動
	awful.key({ modkey, "Shift" }, "Left", function()
		awful.client.swap.bydirection("left")
	end),
	awful.key({ modkey, "Shift" }, "Right", function()
		awful.client.swap.bydirection("right")
	end),
	awful.key({ modkey, "Shift" }, "Up", function()
		awful.client.swap.bydirection("up")
	end),
	awful.key({ modkey, "Shift" }, "Down", function()
		awful.client.swap.bydirection("down")
	end),

	-- 說明
	awful.key({ modkey }, "F1", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),

	-- Reload
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
})

-- tag 切換（Super+1~9，對照 Hyprland）
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { modkey },
		keygroup = "numrow",
		description = "switch tag",
		group = "tag",
		on_press = function(index)
			local t = awful.screen.focused().tags[index]
			if t then
				t:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, "Shift" },
		keygroup = "numrow",
		description = "move to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local t = client.focus.screen.tags[index]
				if t then
					client.focus:move_to_tag(t)
				end
			end
		end,
	}),
})

-- ── Client keybindings ────────────────────────────────────────
client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "fullscreen", group = "client" }),
		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, { description = "maximize", group = "client" }),
	})
end)

-- ── Client mouse ──────────────────────────────────────────────
client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ modkey }, 1, awful.mouse.client.move),
		awful.button({ modkey }, 3, awful.mouse.client.resize),
	})
end)

-- ── Rules ─────────────────────────────────────────────────────
ruled.client.connect_signal("request::rules", function()
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			class = { "Claude", "feh", "Gimp" },
			name = { "Event Tester" },
			type = { "dialog" },
		},
		properties = { floating = true, placement = awful.placement.centered },
	})

	ruled.client.append_rule({
		id = "claude",
		rule = { class = "Claude" },
		properties = {
			floating = true,
			width = 1000,
			height = 750,
			placement = awful.placement.centered,
		},
	})
end)

-- ── 視窗標題欄 ────────────────────────────────────────────────
client.connect_signal("request::titlebars", function(c)
	local buttons = {
		awful.button({}, 1, function()
			c:activate({ context = "titlebar", action = "mouse_move" })
		end),
		awful.button({}, 3, function()
			c:activate({ context = "titlebar", action = "mouse_resize" })
		end),
	}

	awful.titlebar(c, { size = 30, bg = colors.surface0 }).widget = {
		{ -- 左：icon + title
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{
			{ -- 標題
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- 右：按鈕
			awful.titlebar.widget.minimizebutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal,
		},
		layout = wibox.layout.align.horizontal,
	}
end)

-- ── 自動啟動 ──────────────────────────────────────────────────
awful.spawn.with_shell("fcitx5 -d")
awful.spawn.with_shell("dunst")
awful.spawn.with_shell("feh --bg-fill ~/wallpaper.png")

-- ── 焦點跟隨滑鼠 ─────────────────────────────────────────────
client.connect_signal("mouse::enter", function(c)
	c:activate({ context = "mouse_enter", raise = false })
end)
