-- don't modify this file if this is "options.default.lua"
local waywall = require("waywall")
local helpers = require("waywall.helpers")
local utils = require("utils")

local config_path = os.getenv("HOME") .. "/.config/waywall/"
local tools_path = os.getenv("HOME") .. "/.mcsr/"

local xkb_status = utils.make_text {
	text = "WARNING REBIND ALERT",
	dst = { pos_anchor = "bottomleft", item_anchor = "bottomleft", x = 12, y = -60 },
	size = 5,
	color = "#ff0000",
}


-- paths to files. also available in options.path
local path = {
	tools          = tools_path,
	config         = config_path,
	paceman        = tools_path .. "paceman-tracker-0.7.2.jar",
	ninjabrain_bot = tools_path .. "Ninjabrain-Bot-1.5.2.jar",
	oneshot        = config_path .. "images/oneshot_crosshair.png",
	overlay        = config_path .. "images/overlay.png", -- https://qmaxxen.github.io/overlay-gen/more-options/
	overlay_border = config_path .. "images/overlay_border.png",
	x_border       = config_path .. "images/x_border.png",
	y_border       = config_path .. "images/y_border.png",
	tall_border    = config_path .. "images/tall_border.png",
	pie_bg         = config_path .. "images/pie.png",
	pie_border     = config_path .. "images/pie_border.png",
	background     = config_path .. "images/background.png", -- https://wallhaven.cc/w/6l27v6
}

-- # quick resolution config (set from setup.py)

---@type number screen width
local screen_width = 2560
---@type number screen height
local screen_height = 1440
---@type number width of the thin res
local thin_w = 453
---@type number height of the thin res
local thin_h = 1440
---@type number width of the wide res
local wide_w = 2560
---@type number height of the wide res
local wide_h = 453
---@type number width of the overlay mirror
local overlay_w = 1053
---@type number height of the overlay mirror
local overlay_h = 463
---@type number height of the overlay mirror
local pie_d = 200
---@type number width of the border
local border = 5


---@class options
local options = {
	path = path,
	var = {},

	-- https://tesselslate.github.io/waywall/01_options_window.html
	window = {
		width = screen_width,
		height = screen_height,
	},


	-- https://tesselslate.github.io/waywall/01_options_input.html
	input = {
		-- ! key/button remappings and sensitivity are in options.remap and options.sens

		-- XKB keymap options
		layout = "de",
		-- model = "",
		-- rules = "",
		-- variant = "",
		-- options = "",

		-- key repeat
		repeat_rate = 200,
		repeat_delay = 300,

		-- mouse options
		-- confine_pointer = false,
	},


	-- https://tesselslate.github.io/waywall/01_options_theme.html
	theme = {
		-- background = "#00000000",
		background_png = path.background,

		-- cursor_theme = "",
		-- cursor_icon = "",
		cursor_size = 2,

		-- ninb_anchor = "",
		-- ninb_opacity = 1.0,
	},


	-- https://tesselslate.github.io/waywall/01_options_experimental.html
	experimental = {
		-- debug = false,
		jit = true,
		-- tearing = false,
	},


	-- safe guards to disable some features
	safe_guards = {
		-- [STATE OUTPUT] requires https://github.com/tildejustin/state-output / https://github.com/DuncanRuns/Hermes with compat script
		state_output = true,

		-- [FILTER] to disable filters as proposed in the filter ban (see https://discord.com/channels/83066801105145856/416677682290491403/1494468798235807765 in javacord)
		-- requires relaunch of waywall
		filter = true,

		-- [MACRO] to enable one key -> multiple actions
		-- currently in this config it's only used for mpk
		macro = true,

		-- clamps resolution to [340, 16384] for pie chart and rule A.10.4.b
		safe_resolution = true
	},


	-- configure your sensitivity for different resolutions here.
	-- resolutions use the same name as in options.res
	-- https://tesselslate.github.io/waywall/01_options_input.html#mouse-sensitivity
	---@type {_use_maccel: boolean, _normal: number, [string]: number}
	sens = {
		-- use raw_input with maccel, you usually don't need this
		_use_maccel = false,

		-- resolutions
		_normal = 4.51955703,
		tall = 0.21044345,
	},


	-- https://tesselslate.github.io/waywall/01_options_input.html#input-remapping
	-- change your keyboard remaps here
	-- to disable changing a remap based on state, replace the block with nil
	remapped_kb = {
		["MB4"] = "Home",
		["102ND"] = "F3",
		["6"] = "0",
		["LEFTALT"] = "BACKSPACE",
		-- ["CONTROL"] = "LEFTALT",

	},
	normal_kb = {
		-- add any chat/title remaps you want
	},


	-- configure your resolutions here
	-- you can add custom ones that will apply automatically :3
	---@type {[string]: res}
	res = {
		---@class (exact) res: Action
		---@field key string keysym action (https://tesselslate.github.io/waywall/03_lookup_tables.html#keysyms)
		---@field auto_disable? boolean will this get disabled when paused or in chat? [STATE OUTPUT]
		---@field animate? boolean use Char's resize animations https://github.com/char3210/resize_animation/blob/main/resize_animation_waywall.py
		---@field defer? boolean defer the creation of resolution to be able to use sizes of other resolutions
		---@field size number|{h: number|string, w:number|string} the resolution. uses screen.lua for sizing
		---@see Action -- also has fields from actions like chord, ingame_only, f3_safe, consume_input


		thin = {
			key = "*-G",
			ingame_only = true,
			auto_disable = true,
			f3_safe = true,
			size = { w = thin_w, h = thin_h }
			-- size = screen_width / thin_w -- alternative
		},

		wide = {
			key = "*-H",
			ingame_only = true,
			auto_disable = true,
			f3_safe = true,
			size = { w = wide_w, h = wide_h }
			-- size = wide_h / screen_height -- alternative
		},

		tall = {
			key = "*-J",
			ingame_only = false,
			auto_disable = false,
			f3_safe = false,
			defer = true,               -- this resolution depends on the size of thin, so we defer it to be able to use w = "res:thin"
			size = { w = "res:thin", h = 16384 } -- size = 340/16384 won't work as it will clamp to your resolution
			-- size = { w = thin_w, h = 16384 } -- alternative
		},
		

		-- extend here

		preemptive = {
			key = "*-B",
			ingame_only = true,
			auto_disable = true,
			f3_safe = true,
			defer = true, 
			-- size = { w = "res:thin", h = 16384 } -- size = 340/16384 won't work as it will clamp to your resolution
			size = { w = thin_w, h = 16384 } -- alternative
		},
	},


	-- key actions
	-- use keysyms from https://tesselslate.github.io/waywall/03_lookup_tables.html#keysyms
	-- or put nil to disable
	---@class opt_action
	---@field fullscreen? Action|string
	---@field toggle_ninbot? Action|string
	---@field chat_key1? string|{[1]: string, [2]: string}
	---@field chat_key2? string|{[1]: string, [2]: string}
	---@field on_launch opt_on_launch
	---@field extra {[string]: extra_action}`
	action = {
		---@class Action
		---@field key string keysym action (https://tesselslate.github.io/waywall/03_lookup_tables.html#keysyms)
		---@field chord? string|string[] extra key/keys that should be held to enable binds such as tab+b. uses keycodes (https://tesselslate.github.io/waywall/03_lookup_tables.html#keycodes)
		---@field ingame_only? boolean will this only work when ingame? (not paused or in chat) [STATE OUTPUT]
		---@field f3_safe? boolean will this be disabled when using an f3 bind?
		---@field consume_input? boolean will this consume the input? nil uses the function output


		-- waywall.toggle_fullscreen
		fullscreen = { key = "Ctrl-O" },

		-- show ninjabrain bot
		toggle_ninbot = { key = "N" },

		-- disable remaps when pressing the chat keys, can desync if not using [STATE OUTPUT]
		-- some keys have different names in keysyms and keycodes https://tesselslate.github.io/waywall/03_lookup_tables.html#keycodes
		-- for those, use {"keysym", "keycode"} (like for Enter: { "Return", "Enter" })
		chat_key1 = "udiaeresis",
		chat_key2 = nil,
		-- chat_key1 = "Insert", chat_key2 = nil -- alternative for when not using [STATE OUTPUT]

		-- functions that will start on launch
		---@class opt_on_launch: Action
		---@field [integer|string] fun(options: options): boolean|nil
		on_launch = {
			-- key to reactivate
			key = "Ctrl-Shift-R",

			-- functions that get run, with the options as the param. return true if anything was launched
			-- these get run infinitelly until it doesn't return true, with an error in case it loops too much
			ninjabrain_bot = function(options)
				if not utils.is_running("Ninjabrain.*\\.jar") then
					waywall.exec("java -Dawt.useSystemAAFontSettings=on -jar " .. options.path.ninjabrain_bot)
					return true
				end
			end,

			-- extend here

			-- Note: objects set in here can disappear when collected by the Lua virtual machine,
			-- to set persistent objects, add them to options.objects with enabled set to true
		},


		-- auto generate custom actions :3
		extra = {
			---@class (exact) extra_action: Action
			---@field exec fun(options: options): boolean?
			---@see Action


			launch_paceman = {
				-- key to activate the action
				key = "Shift-P",

				-- function that gets run, with the options as the param
				exec = function(options)
					if not utils.is_running("paceman..*") then
						waywall.exec("java -jar " .. options.path.paceman .. " --nogui")
					end
				end
			},


			-- show ninjabrain bot for 5 seconds when copying coords
			copy_coords = {
				key = "*-C",

				exec = function(options)
				 	if not waywall.get_key("F3") then return false end
				 	-- dont activate if ninbot is already shown via keybind
				 	if waywall.floating_shown() and (options.var.hide_ms or 0) <= waywall.current_time() then return false end

				 	waywall.press_key("C")
				 	waywall.show_floating(false)

				 	-- local seconds = 0.1
				 	-- local show_ms = seconds * 1000
				 	-- local current_ms = waywall.current_time()
				 	-- local new_hide_ms = current_ms + show_ms

				 	-- options.var.hide_ms = math.max((options.var.hide_ms or 0), new_hide_ms)

				 	-- waywall.sleep(show_ms)
				 	-- if not waywall.floating_shown() then return end

				 	-- if options.var.hide_ms <= waywall.current_time() then
				 	-- 	waywall.show_floating(false)
				 	-- end
				end
			},

			remap_toggle = {
			  	key = "udiaeresis",

  				exec = function(options)
    				options.var.paused_xkb = not options.var.paused_xkb
    				if (options.var.paused_xkb) then
						waywall.set_keymap(options.input)
      				waywall.set_remaps(options.normal_kb)
						xkb_status(true)
    				else
						waywall.set_keymap({ layout = "mc" })
      					waywall.set_remaps(options.remapped_kb)
						xkb_status(false)
    				end
  				end
			},

			-- extend here
		},
	},


	--- define mirrors / images / text here.
	--- all src and dst definitions are passed to `screen.lua`
	--- that handles automatic positioning based on anchors
	---@see RectOptions
	---
	--- - mirrors:
	---   - `utils.make_mirror`: standard mirror
	---   - `utils.text_mirror`: mirror for text, uses a [FILTER] and an optional shadow
	---   - `utils.f3_mirror`: helper for text_mirror to select specific text in the f3 menu, uses a [FILTER] for text and shadow
	---   - `utils.f3_mirror_basic`: helper for make_mirror to select specific text in the f3 menu
	--- - images: `utils.make_image`
	--- - text: `utils.make_text`
	---
	--- when importing scene objects from other configs, add `anchor = "topleft"` to `src` and `dst`
	---
	---@type {[string]: object}
	objects = {
		---@class object
		---@field enabled? table|true resolutions where the object is enabled, or true if persistent
		---@field action? Action|string set this to be able to activate the object with an action
		---@field [integer|string] fun(enable: boolean|"toggle", options: options) named/unnamed function
		---@see Action


		-- y_border = {
		-- 	enabled = utils.set { "thin" },
		-- 	utils.make_image {
		-- 		path = path.y_border,
		-- 		dst = { w = thin_w + border * 2, h = math.min(thin_h + border * 2, screen_height) }
		-- 	},
		-- },

		-- x_border = {
		-- 	enabled = utils.set { "wide" },
		-- 	utils.make_image {
		-- 		path = path.x_border,
		-- 		dst = { w = math.min(wide_w + border * 2, screen_width), h = wide_h + border * 2 }
		-- 	},
		-- },

		tall_border = {
			enabled = utils.set { "tall" },
			utils.make_image {
				path = path.tall_border,
				dst = { w = thin_w + border * 2, h = 1 }
			},
		},

		e = {
			enabled = utils.set { "thin", "tall" },
			utils.f3_mirror {
				src = { gui_scale = 1, line = 4, x = 1, w = 49 }, -- <- replace gui_scale if your resolution is 4k+
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "bottom", scale = 4 }
			}

			-- alternative a) without [FILTER] or b) with a color change
			-- utils.f3_mirror_basic {
			-- 	src = { gui_scale = 1, line = 4, x = 1, w = 49 }, -- <- replace gui_scale if your resolution is 4k+
			-- 	dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "bottom", scale = 4 },
			-- 	-- shader = "none", color_key = { input = "#DDDDDD", output = "#FFFFFF" } -- if you wan't to change the color without changing the shader like gore's generic
			-- }
		},

		eye_measure = {
			enabled = utils.set { "tall" },
			utils.make_mirror {
				src = { x = 0, y = 0, w = 30, h = 580 }, -- set w to overlay width from https://qmaxxen.github.io/overlay-gen/more-options/
				dst = { pos_anchor = "left", w = overlay_w, h = overlay_h, x = (screen_width - thin_w) / 4 },
			},
			utils.make_image {
				path = path.overlay,
				dst = { pos_anchor = "left", w = overlay_w, h = overlay_h, x = (screen_width - thin_w) / 4 },
				depth = 1
			},
			utils.make_image {
				path = path.overlay_border,
				dst = { pos_anchor = "left", w = overlay_w, h = overlay_h, x = (screen_width - thin_w) / 4 },
				depth = 2
			}
		},

		pie_chart = {
			enabled = utils.set { "thin", "tall", "preemptive" },
			utils.make_mirror {
				src = { x = 0, y = -235, w = 340, h = 170, anchor = "bottomright" },
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "top", w = pie_d, h = pie_d, },
				shader = "pie_chart", depth = 1, multi_res = true -- multi_res is needed because the position shifts based on the active resolution
				-- pie_chart uses [FILTER], set shader to "pie_crop" to use a filter compatible with the filter ban
			},
			utils.make_image {
				path = path.pie_bg, depth = 0,
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "top", w = pie_d, h = pie_d, }
			},
			utils.make_image {
				path = path.pie_border, depth = 2,
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "top", w = pie_d, h = pie_d, }
			}
		},

		-- alternative pie chart using per-color mirrors like gore's generic config
		-- pie_chart = {
		-- 	enabled = utils.set{"thin", "tall"},
		-- 	utils.make_mirror{
		-- 		src = { x = 0, y = -235, w = 340, h = 170, anchor = "bottomright"},
		-- 		dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "top", w = pie_d, h = pie_d, },
		-- 		depth = 1, multi_res = true,
		-- 		color_key = {
		-- 			-- yeah, we're supporting multiple color keys here
		-- 			{ input = "#EC6E4E", output = "#EC6E4E" },
		-- 			{ input = "#46CE66", output = "#46CE66" },
		-- 			{ input = "#CC6C46", output = "#CC6C46" },
		-- 			{ input = "#464C46", output = "#464C46" },
		-- 			{ input = "#E446C4", output = "#E446C4" }
		-- 		}
		-- 	},
		-- },

		pie_percent = {
			enabled = utils.set { "thin", "tall", "preemptive" },
			utils.text_mirror {
				src = { x = -60, y = -188, w = 32, h = 32, anchor = "bottomright" },
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "left", x = pie_d / 2, y = pie_d / 2, scale = 4 },
				shader = "pie_text", shadow = { shader = "pie_text_shadow" }, multi_res = true
			}

			-- alternative without [FILTER]
			--utils.make_mirror {
			--src = { x = -60, y = -196, w = 32, h = 24, anchor = "bottomright" },
			--dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "left", x = pie_d/2, y = pie_d/2, scale = 4 },
			--multi_res = true
			--}
		},

		pie_numbers = {
			enabled = utils.set { "_normal" },
			utils.make_mirror {
				src = { x = -180, y = -156, w = 150, h = 64, anchor = "bottomright" },
				dst = { x = -170, y = -500, scale = 6, pos_anchor = "bottomright" },
				depth = 2,
				color_key = {
		 			{ input = "#C2CBC2", output = "#C2CBC2" },
		 			{ input = "#C2CBC2", output = "#C2CBC2" },
		 			{ input = "#6543CA", output = "#6543CA" },
		 			{ input = "#63CBC2", output = "#63CBC2" },
		 			{ input = "#C4C46D", output = "#C4C46D" },
					{ input = "#E145C2", output = "#E145C2" }
		 		},
			},

			-- alternative without [FILTER]
			-- action = "Ctrl-F3", -- remove `enabled` to make it toggle only with this action
			-- utils.make_mirror {
			-- 	src = { x = -60, y = -196, w = 32, h = 24, anchor = "bottomright" },
			-- 	dst = { scale = 4, anchor = "bottomright" },
			-- 	multi_res = true
			-- },
		},

		pie_numbers_shadow = {
			enabled = utils.set { "_normal" },
			utils.make_mirror {
				src = { x = -180, y = -156, w = 150, h = 64, anchor = "bottomright" },
				dst = { x = -165, y = -495, scale = 6, pos_anchor = "bottomright" },
				depth = 1,
				color_key = {
		 			{ input = "#C2CBC2", output = "#1d1e1d" },
		 			{ input = "#C2CBC2", output = "#343734" },
		 			{ input = "#6543CA", output = "#170f2f" },
		 			{ input = "#63CBC2", output = "#17302e" },
		 			{ input = "#C4C46D", output = "#37371e" },
					{ input = "#E145C2", output = "#381030" }
		 		},
				
			},

			-- alternative without [FILTER]
			-- action = "Ctrl-F3", -- remove `enabled` to make it toggle only with this action
			-- utils.make_mirror {
			-- 	src = { x = -60, y = -196, w = 32, h = 24, anchor = "bottomright" },
			-- 	dst = { scale = 4, anchor = "bottomright" },
			-- 	multi_res = true
			-- },
		},

		glowdar = {
			enabled = utils.set { "_normal" },
			utils.text_mirror {
				src = { x = -60, y = -196, w = 32, h = 24, anchor = "bottomright" },
				dst = { x = -170, y = -305, scale = 4, pos_anchor = "bottomright" },
				shader = "pie_text", shadow = { shader = "pie_text_shadow" }
			},

			-- alternative without [FILTER]
			-- action = "Ctrl-F3", -- remove `enabled` to make it toggle only with this action
			-- utils.make_mirror {
			-- 	src = { x = -60, y = -196, w = 32, h = 24, anchor = "bottomright" },
			-- 	dst = { scale = 4, anchor = "bottomright" },
			-- 	multi_res = true
			-- },
		},

		oneshot = {
			enabled = utils.set { "tall" },
			utils.make_image {
				path = path.oneshot,
				dst = { w = 100, h = 100 }
			},
		},

		-- extend here

		-- f3block = {
		-- 	enabled = utils.set { "_normal" },
		-- 	utils.f3_mirror {
		-- 		src = { gui_scale = 3, line = 11, x = 33, w = 88 },
		-- 		dst = "src", -- copy position from src
		-- 	},
		-- }

		facing = {
		  enabled = utils.set { "_normal" },
		 	utils.f3_mirror_basic {
		 		src = { gui_scale = 4, line = 13, x = 116, w = 62 },
		 		dst = "src",
				color_key = { input = "#DDDDDD", output = "#00ff00" }
			}
		},

		chunk_coordinates = {
		  enabled = utils.set { "_normal" },
		 	utils.f3_mirror_basic {
		 		src = { gui_scale = 4, line = 12, x = 79, w = 100 },
		 		dst = "src",
				color_key = { input = "#DDDDDD", output = "#ff0000" }
			}
		},

		-- difficulty = {
		--   enabled = utils.set { "_normal" },
		--  	utils.f3_mirror_basic {
		--  		src = { gui_scale = 4, line = 19, x = 80, w = 10 },
		--  		dst = { x = -50, y = -450, w = 300,  h = 250, pos_anchor = "bottom" },
		-- 		depth = 2,
		-- 		color_key = { input = "#DDDDDD", output = "#ff0000" }
		--  	}
		-- },

		-- difficulty_shadow = {
		--   enabled = utils.set { "_normal" },
		--  	utils.f3_mirror_basic {
		--  		src = { gui_scale = 4, line = 19, x = 80, w = 10 },
		--  		dst = { x = -45, y = -445, w = 300,  h = 250, pos_anchor = "bottom" },
		-- 		depth = 1,
		-- 		color_key = { input = "#DDDDDD", output = "#4e1919" }
		-- 	}
		-- },

		--timer = {
		-- 	enabled = utils.set { "_normal" },
		-- 	utils.make_mirror {
		--		src = { anchor = "topright", x = 0, y = 0, w = 600, h = 120 },
		-- 		dst = { pos_anchor = "topright", item_anchor = "topright", w = 600, h = 120 },
		-- 		shader = "timer"
		--	}
		-- }

	},


	-- [MACRO] to quickly launch mpk
	-- ! WARNING: there are little to none safeguards in place, and this can do unexpected actions if not used on 1.16.1
	---@class mpk
	mpk = {
		-- start mpk, used from the title screen
		launch_key = "F9",
		launch_macro = { "Esc", "Esc", "Esc", "Tab", "Space", "Tab", "Tab", "Tab", "Space", "Tab", "Space", "Space", "Tab", "Tab", "Tab", "Tab", "Tab", "Tab", "Space" },

		-- quit the world (can be used outside of mpk)
		quit_key = "F10",
		quit_macro = { "Esc", "Esc", "Tab", "Space", "Esc", "Tab", "Tab", "Tab", "Tab", "Tab", "Tab", "Tab", "Tab", "Space" },

		-- saved hotbar row the mpk is stored in. (hold your hotbar restore key to automatically load it)
		-- uses [STATE OUTPUT] to detect loading into the world after the launch key was pressed
		load = "1"
	},
}

return options
