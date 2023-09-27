-- -----------------------------------------------

-- [状態パターンモジュール]

-- -----------------------------------------------
local M = {}
-- --------------------------------------------------
-- 状態共有用
-- --------------------------------------------------
local data = require ("main.data")
-- --------------------------------------------------
-- 状態変更
-- --------------------------------------------------
function M.transition(self, state_name, sdata)
	print("transition", self.state and self.state.name or "none", "-->", self.states[state_name].name)
	if self.state and self.state.exit then
		self.state.exit(self)
	end
	-- 前の状態名と新しい状態名を一時保存
	data.pre_state[self.script_name] = self.state.name
	data.game_state[self.script_name] = state_name

	self.state = self.states[state_name]
	if self.state.enter then
		self.state.enter(self, sdata)
	end
end
function M.update(self, dt)
	if self.state.update then
		self.state.update(self, dt)
	end
end
function M.on_input(self, action_id, action)
	if self.state.input then
		self.state.input(self, action_id, action)
	end
end
function M.on_message(self, message_id, message, sender)
	if self.state.message then
		self.state.message(self, message_id, message, sender)
	end
end
return M