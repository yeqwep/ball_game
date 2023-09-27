-- --------------------------------------------------

-- [スコア値管理]

-- --------------------------------------------------
local s_manager = {}
-- モジュール
local common = require "tool.common"
local save_handler = require "main.save_handler"
-- 共通のデータ
local data = require ("main.data")
local const = require "tool.const"

s_manager.view_score = 0		-- 現在の表示中のスコア
local MAX_SCORE= 99999			-- スコアの上限
-- ----------------------
-- 動作
-- ----------------------
-- 更新アニメーション
function s_manager.anim(self, node)
	local target = data.score
	local start = s_manager.view_score
	if self.count_up_timer then
		timer.cancel(self.count_up_timer)
		self.count_up_timer = nil
	end
	local t = 0.03		-- ステップ
	local num = start

	self.count_up_timer = timer.delay(t,true,function(self, handle, time_elapsed)
		local inc = 1		-- 増加量
		if target-num > 20 then
			inc = const.FLOOR((target-start-20)/50)
		end
		num = num + inc
		if num >= target then
			num = target
			timer.cancel(handle)
			self.count_up_timer = nil
		end
		local text = common.comma_value(num)
		gui.set_text(node,text)
	end)
	s_manager.view_score = data.score
end
-- 表示アニメーションなし
function s_manager.set(self, node)
	if self.count_up_timer then
		timer.cancel(self.count_up_timer)
		self.count_up_timer = nil
	end
	local text = common.comma_value(data.score)
	gui.set_text(node, text)
	s_manager.view_score = data.score
end
-- データ値更新
function s_manager.up_down(num)
	data.score = data.score + num
	if data.score > MAX_SCORE then
		data.score = MAX_SCORE
	elseif data.score < 0 then
		data.score = 0
	end
end
-- ベストスコア更新
function s_manager.save_best()
	local is_best = false
	-- 新ベストスコアの時
	if data.pre_score < data.score then
		is_best = true
		data.best_score = data.score
		-- スコア保存
		save_handler.savegamefile()
	end
	return is_best
end
-- 初期化
function s_manager.reset()
	data.pre_score = data.best_score
	data.score = 0
	s_manager.view_score = 0
	print("pre_best",data.pre_score)
end

return s_manager