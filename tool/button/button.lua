-- --------------------------------------------------

-- [GUIボタンを作るモジュール]

-- --------------------------------------------------
local M = {}

local common = require "tool.common"
local const = require "tool.const"
-- ボタンの表現動作
local func = require"tool.button.button_func"
-- --------------------------------------------------
-- button
-- node : node name
-- callback : callback function
-- --------------------------------------------------
function M.create(node, callback, sound)
	local button = {pressed = false, hover = false, use = true}	-- use=trueの時押せる
	-- ボタンの初期状態
	func.init_button(node, button, sound)
	function button.on_input(action_id, action)
		if common.gui_is_enabled(node) and gui.is_enabled(node) and button.use then
			local over = gui.pick_node(node, action.x, action.y)
			if over and button.hover == false then
				button.hover = true
				func.hover(node, button)
			elseif over == false and button.hover then
				button.hover = false
				func.hover_out(node, button)
			end
			-- ボタン押したとき
			if button.hover and action.pressed and action_id == const.TOUCH then
				button.pressed = true
				func.pressed(node, button)
			-- ボタンを押して離したとき
			elseif action.released and button.pressed and action_id == const.TOUCH then
				button.pressed = false
				func.released(node, button, callback)
			end
		end
	end
	-- ボタン使用できるかセット
	function button.set_use(use)
		button.use = use
		func.use_setting(node, button)
	end
	return button
end
-- --------------------------------------------------
-- togglebutton
-- node : node name
-- flag : flag
-- callback : callback function
-- --------------------------------------------------
function M.create_toggle(node, flag, callback)
	local toggle = {pressed = false, use = true}
	toggle.anim = {on = hash("on"), off = hash("off")}
	func.init_toggle(node, toggle, flag)

	function toggle.on_input(action_id, action, flag)
		local over = gui.pick_node(node, action.x, action.y)
		if common.gui_is_enabled(node) and gui.is_enabled(node) and toggle.use and over then
			if action.pressed and action_id == const.TOUCH then
				toggle.pressed = true
				func.pressed_toggle(node, toggle)
			elseif action.released and toggle.pressed and action_id == const.TOUCH then
				toggle.pressed = false
				flag = not flag
				func.released_toggle(node, toggle, callback, flag)
			end
		end
	end
	-- ボタン使用できるかセット
	function toggle.set_use(use)
		toggle.use = use
		func.use_setting_toggle(node, toggle)
	end
	return toggle

end
return M