-- --------------------------------------------------

-- [button.luaの詳細設定用ファイル]

-- --------------------------------------------------
local M = {}
-- --------------------------------------------------
-- button
-- 見た目設定初期化
-- ホバーしたとき、ホバー終わったとき、押したとき、離したとき
-- 使用可能状態のとき
-- --------------------------------------------------
-- 見た目設定初期化
function M.init_button(node, button, sound)
	-- 音設定
	if sound then
		button.sound = "main:/sound#" .. sound
	else
		button.sound = "main:/sound#button"
	end
end
-- ホバーしたとき
function M.hover(node, button)
	gui.cancel_animation(node, gui.PROP_SCALE)
	local box_scale = vmath.vector3(1.1)
	gui.animate(node, gui.PROP_SCALE, box_scale, gui.EASING_OUTEXPO, 0.55, 0)
end
-- ホバー終わったとき
function M.hover_out(node, button)
	gui.cancel_animation(node, gui.PROP_SCALE)
	local box_scale = vmath.vector3(1)
	gui.animate(node, gui.PROP_SCALE, box_scale, gui.EASING_OUTEXPO, 0.55, 0)
end
-- 押したとき
function M.pressed(node, button)
	gui.cancel_animation(node, gui.PROP_SCALE)
	gui.animate(node, gui.PROP_SCALE, vmath.vector3(0.95), gui.EASING_OUTEXPO, 0.55, 0)
end
-- 離したとき
function M.released(node, button, callback)
	gui.set_scale(node,vmath.vector3(1))
	-- ボタン上にあるとき
	if button.hover then
		sound.play(button.sound)
		callback(button)
		button.hover = false
	end
end
-- 使用可能状態のとき
function M.use_setting(node, button)
	if button.use then
		gui.set_color(node,vmath.vector4(1))
	else
		gui.set_color(node,vmath.vector4(0.3,0.3,0.3,1))
	end
end
-- --------------------------------------------------
-- togglebutton
-- 見た目設定初期化
-- 押したとき、離したとき
-- 使用可能状態のとき
-- --------------------------------------------------
-- 見た目設定初期化
function M.init_toggle(node, toggle, flag)
	gui.play_flipbook(node, flag and toggle.anim.on or toggle.anim.off)
end
-- 押したとき
function M.pressed_toggle(node, toggle)
end
-- 離したとき
function M.released_toggle(node, toggle, callback, flag)
	gui.play_flipbook(node, flag and toggle.anim.on or toggle.anim.off)
	callback(toggle,flag)
end
-- 使用可能状態のとき
function M.use_setting_toggle(node, toggle)
	if toggle.use then
		gui.set_color(node,vmath.vector4(1))
	else
		gui.set_color(node,vmath.vector4(0.3,0.3,0.3,1))
	end
end
return M