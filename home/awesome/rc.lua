-- ══════════════════════════════════════════════════════════════
-- rc.lua  –  Catppuccin Mocha + bling (Awesome 4.3 修正版)
-- ══════════════════════════════════════════════════════════════

pcall(require, "luarocks.loader")

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
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
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.floating,
	awful.layout.suit.max,
	bling.layout.mstab,
	bling.layout.centered,
}

-- ── Tags & Wibar ──────────────────────────────────────────────
awful.screen.connect_for_each_screen(function(s)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		height = 36,
		bg = colors.base .. "cc",
		fg = colors.text,
	})

	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = gears.table.join(
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
			end)
		),
	})

	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = gears.table.join(awful.button({}, 1, function(c)
			c:activate({ context = "tasklist", action = "toggle_minimization" })
		end)),
	})

	local clock = wibox.widget.textclock('<span color="' .. colors.lavender .. '"> %H:%M</span>')

	s.mywibox:setup({
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
	})
end)

-- ── Global Bindings ───────────────────────────────────────────
local globalkeys = gears.table.join(
	-- 程式快捷鍵
	awful.key({ modkey }, "q", function()
		awful.spawn(terminal)
	end),
	awful.key({ modkey }, "e", function()
		awful.spawn(filemanager)
	end),
	awful.key({ modkey }, "r", function()
		awful.spawn(launcher)
	end),
	awful.key({ modkey }, "l", function()
		awful.spawn("xscreensaver-command -lock")
	end),
	awful.key({ modkey, "Shift" }, "e", function()
		awful.spawn("wlogout")
	end),

	-- 截圖
	awful.key({}, "Print", function()
		awful.spawn("scrot -e 'xclip -selection clipboard -t image/png < $f'")
	end),
	awful.key({ modkey, "Shift" }, "s", function()
		awful.spawn("scrot -s -e 'xclip -selection clipboard -t image/png < $f'")
	end),

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

	-- 焦點與視窗移動
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

	awful.key({ modkey, "Shift" }, "Left", function()
		awful.client.swap.bydirection("left")
	end),
	awful.key({ modkey, "Shift" }, "Right", function()
		awful.client.swap.bydirection("right")
	end),

	-- WM 控制
	awful.key({ modkey }, "F1", hotkeys_popup.show_help),
	awful.key({ modkey, "Control" }, "r", awesome.restart)
)

-- 數字鍵切換 Tag (1-9)
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end),
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end)
	)
end

root.keys(globalkeys)

-- ── Client Bindings ───────────────────────────────────────────
local clientkeys = gears.table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end),
	awful.key({ modkey }, "c", function(c)
		c:kill()
	end),
	awful.key({ modkey }, "v", awful.client.floating.toggle),
	awful.key({ modkey }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end)
)

-- ── Rules (Awesome 4.3 語法修正) ───────────────────────────────
awful.rules.rules = {
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},
	{
		rule_any = {
			class = { "Claude", "feh", "Gimp" },
			type = { "dialog" },
		},
		properties = { floating = true, placement = awful.placement.centered },
	},
	{
		rule = { class = "Claude" },
		properties = { width = 1000, height = 750 },
	},
}

-- ── Signals ───────────────────────────────────────────────────
client.connect_signal("manage", function(c)
	if not awesome.startup then
		awful.placement.no_offscreen(c)
	end
end)

client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- ── 自動啟動 ──────────────────────────────────────────────────
awful.spawn.with_shell("fcitx5 -d")
awful.spawn.with_shell("dunst")
