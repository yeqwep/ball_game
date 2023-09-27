-- --------------------------------------------------

-- [セーブデータ管理モジュール]

-- --------------------------------------------------
local M = {}
-- 共通のデータ
local data = require ("main.data")
-- セーブ名
M.APP_NAME = "ssrb_ball"
M.SAVE_FILE_NAME = "savefile"
M.SETTINGS_FILE_NAME = "settings"

function M.loadgamefile()
	local file = sys.load(sys.get_save_file(M.APP_NAME, M.SAVE_FILE_NAME))
	data.best_score = file.best_score
	if data.best_score == nil then
		data.best_score = 0
	end
	print("load best score",data.best_score)
end

function M.savegamefile()
	if data.best_score < data.score then
		data.best_score = data.score
	end
	local file = {
		best_score = data.best_score
	}
	sys.save(sys.get_save_file(M.APP_NAME, M.SAVE_FILE_NAME), file)
end

function M.loadsettings()
	local file = sys.load(sys.get_save_file(M.APP_NAME, M.SETTINGS_FILE_NAME))

	data.bgm = file.bgm
	data.sound = file.sound

	if data.bgm == nil then
		data.bgm = 1
	end
	if data.sound == nil then
		data.sound = 1
	end
	print("load setting",data.bgm,data.sound)
end

function M.savesettings()
	local file = {
		bgm = data.bgm,
		sound = data.sound
	}
	sys.save(sys.get_save_file(M.APP_NAME, M.SETTINGS_FILE_NAME), file)
end

function M.clearsavegame()
	local file = {
	}
	sys.save(sys.get_save_file(M.APP_NAME, M.SAVE_FILE_NAME), file)
	file = {
	}
	sys.save(sys.get_save_file(M.APP_NAME, M.SETTINGS_FILE_NAME), file)
end

return M