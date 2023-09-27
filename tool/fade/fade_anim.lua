-- --------------------------------------------------

-- [フェードインアウトの画面覆うのを作る]

-- --------------------------------------------------
local M = {}
-- ---------------------------------
-- 表示後動作
-- ---------------------------------
--フェードアウト終了関数
local function fade_out_done(fades)
	msg.post(fades.sender, hash("fade_out_done"))
end
--フェードイン終了関数
local function fade_in_done(fades)
	msg.post(fades.sender, hash("fade_in_done"))
	gui.delete_node(fades.shade)
	fades.shade = nil
end
-- ---------------------------------
-- フェード生成
-- ---------------------------------
-- GUIレイヤーの時間、色の設定
local function set_option(message)
	-- 時間、色の設定
	local fade_time = tonumber(message.fade_time)
	if not message.fade_time then
		fade_time = 0.2
	end
	local fade_color = message.fade_color
	if not message.fade_color then
		fade_color = vmath.vector4(0, 0, 0, 1)
	end
	return fade_time, fade_color
end
-- フェード用の四角作成
local function create_shade()
	local width, height = gui.get_width(), gui.get_height() -- GUIの縦横幅
	local position = vmath.vector3(width / 2, height / 2, 0) -- 位置
	local size = vmath.vector3(width * 1, height * 1, 0) -- 大きさ
	local shade = gui.new_box_node(position, size)
	gui.set_adjust_mode(shade, gui.ADJUST_ZOOM)
	gui.set_color(shade, vmath.vector4(0))
	return shade
end
-- ---------------------------------
-- フェードアニメ
-- ---------------------------------
local function fade_out(fades, fade_time, fade_color)
	gui.animate(
		fades.shade,
		gui.PROP_COLOR,
		fade_color,
		gui.EASING_OUTQUAD,
		fade_time,
		0.0,
		function()
			fade_out_done(fades)
		end
	)
	fades.show = true
end

local function fade_in(fades, fade_time, fade_color)
	gui.set_color(fades.shade,fade_color)
	fade_color.w = 0
	gui.animate(
		fades.shade,
		gui.PROP_COLOR,
		fade_color,
		gui.EASING_OUTQUAD,
		fade_time,
		0.0,
		function()
			fade_in_done(fades)
		end
	)
	fades.show = false
end
-- ---------------------------------
-- 初期化
-- message = {fade_time = 0, fade_color = vmath.vector4()}
-- フェード時間、カラーを設定可能
-- ---------------------------------
function M.init()
	local fades = {sender = nil, shade = nil, show = false}
		function fades.fade(message, sender)
			fades.sender = sender
			local fade_time,fade_color = set_option(message)
			if fades.show == false and fades.shade == nil then
				fades.shade = create_shade()
				fade_out(fades, fade_time, fade_color)
			elseif fades.show == true and fades.shade ~= nil then
				fade_in(fades, fade_time, fade_color)
			else
				print("fade failed")
			end
		end
		function fades.fade_in(message, sender)
			fades.sender = sender
			local fade_time,fade_color = set_option(message)
			if fades.shade == nil then
				fades.shade = create_shade()
				fade_in(fades, fade_time, fade_color)
			elseif fades.shade ~= nil then
				fade_in(fades, fade_time, fade_color)
			end
		end
		function fades.fade_out(message, sender)
			fades.sender = sender
			local fade_time,fade_color = set_option(message)
			if fades.shade == nil then
				fades.shade = create_shade()
				fade_out(fades, fade_time, fade_color)
			elseif fades.shade ~= nil then
				fade_out(fades, fade_time, fade_color)
			end
		end
	return fades
end
return M