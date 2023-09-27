-- --------------------------------------------------

-- [いろいろな一般的な動作のモジュール]

-- --------------------------------------------------
local M = {}
local const = require "tool.const"
-- -----------------------------------------------
-- 音量調整
-- -----------------------------------------------
function M.set_gain(bgm, se)
	if bgm then
		sound.set_group_gain("bgm", bgm)
		-- print("bgm is " .. bgm)
	end
	if se then
		sound.set_group_gain("se", se)
		-- print("se is " .. se)
	end
end
-- -----------------------------------------------
-- カラーコード変換
-- -----------------------------------------------
function M.hex2rgba(hex, w)
	local alpha = 1
	if w then
		alpha = w
	end
	hex = hex:gsub("#", "")
	local rgba =
		vmath.vector4(
		tonumber("0x" .. hex:sub(1, 2)) / 255,
		tonumber("0x" .. hex:sub(3, 4)) / 255,
		tonumber("0x" .. hex:sub(5, 6)) / 255,
		alpha
	)
	return rgba
end
-- -----------------------------------------------
-- タイルマップとの座標変換 
-- -----------------------------------------------
function M.world2tile(p)
	return vmath.vector3(const.FLOOR((p.x + M.TILE_SIZE) / M.TILE_SIZE), const.FLOOR((p.y + M.TILE_SIZE) / M.TILE_SIZE), p.z)
end

function M.tile2world(p)
	return vmath.vector3((p.x * M.TILE_SIZE) - (M.TILE_SIZE / 2), (p.y * M.TILE_SIZE) - (M.TILE_SIZE / 2), p.z)
end
-- -----------------------------------------------
-- 範囲チェック
-- -----------------------------------------------
--有効範囲(rect)内かどうか判定
function M.ptinrect(x, y, rect)
    local r = false
    if x > rect.x and x < rect.z and y > rect.y and y < rect.w then
        r = true
    end
    return r
end
-- -----------------------------------------------
-- 文章のカスタムリソースのLua読み込み
-- -----------------------------------------------
function M.text_lua_loader(namespace_id, language)
	local intl_dir = "/res/text"
	local file = sys.load_resource(intl_dir .. "/" .. language .. "/" .. namespace_id .. "_" .. language .. ".lua")
	if not file then
		return nil
	end

	local chunk, parse_error = loadstring(file)
	if not chunk then
		-- print(parse_error)
		return nil
	end

	local data
	local status, error =
		pcall(
		function()
			data = chunk()
		end
	)
	if not status then
		-- print(error)
		return nil
	end

	return data
end
-- -----------------------------------------------
-- 一般
-- -----------------------------------------------
-- 1次元の要素番号numを2次元x,yにする
-- x 折り返し
function M.get_index(num, x)
	local index = {x = 0, y = 0}
	index.x = ((num - 1) % x) + 1
	index.y = const.FLOOR((num - 1) / x) + 1
	return index
end
-- 数値のテーブルの合計
function M.sum(t)
	local sum = 0
	for k, v in pairs(t) do
		sum = sum + v
	end
	return sum
end
-- 符号取得
function M.sign(n)
	return n > 0 and 1 or (n < 0 and -1 or 0)
end
-- 大きい順に並び替え
function M.sort_big(array)
	if #array > 1 then
		for i = 1, #array do
			if array[i + 1] > array[i] then
				local temp = array[i]
				array[i] = array[i + 1]
				array[i + 1] = temp
			end
		end
	end
	return array
end
-- ３桁おきにコンマつける
-- http://richard.warburton.it
function M.comma_value(n)
	local left, num, right = string.match(n, "^([^%d]*%d)(%d*)(.-)$")
	return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end
-- 桁数計算
function M.countDigits(num)
	local numStr = tostring(num)
	return #numStr
end
-- -----------------------------------------------
-- テーブルコピー
-- -----------------------------------------------
-- 浅いテーブルコピー
function M.table_copy(old)
	local new_t = {}
	for k, v in pairs(old) do
		new_t[k] = v
	end
	-- pprint(new)
	return new_t
end
-- ディープテーブルコピー
-- テーブルはデータ型なので値を渡そうとしても参照してしまう
-- そこで新しいテーブルを作って要素をひとつづつ移す必要がある
function M.deepcopy(o, seen)
	seen = seen or {}
	if o == nil then
		return nil
	end
	if seen[o] then
		return seen[o]
	end

	local no = {}
	seen[o] = no
	setmetatable(no, M.deepcopy(getmetatable(o), seen))

	for k, v in next, o, nil do
		k = (type(k) == "table") and M.deepcopy(k, seen) or k
		v = (type(v) == "table") and M.deepcopy(v, seen) or v
		no[k] = v
	end
	return no
end
-- -----------------------------------------------
-- gui check
-- -----------------------------------------------
-- クリックしたノードが有効か
function M.hit_test(node, action_id, action)
    local hit = gui.pick_node( node, action.x, action.y )
    local touch = action_id == const.TOUCH
    return touch and hit and gui.is_enabled(node)
end
-- 触ったノードが有効か
function M.hover_test(node, action_id, action)
    local hover = gui.pick_node( node, action.x, action.y )
    return hover and gui.is_enabled(node)
end
-- 触った（action_id）の名前があるかどうか判定
function M.safe_get_node(node)
    --ノードがあるか、あったら名前を返す
    if
        pcall(
            function()
                gui.get_node(node)
            end
        )
     then
        return gui.get_node(node)
    else
        return nil
    end
end
-- ノードが有効か判定
function M.gui_is_enabled(node)
	local parent = gui.get_parent(node) --親が無かったらnil。あったら名前を返す
	if parent then
		return M.gui_is_enabled(parent) --親の名前を返す
	end
	return gui.is_enabled(node) --ノードが有効ならtrueを返す。無効ならfalseを返す
end

return M
