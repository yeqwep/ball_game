-- --------------------------------------------------

-- [プロジェクト問わずよく使う定数]

-- --------------------------------------------------
local const = {}
-- --------------------------------------------------------
-- 入力
-- --------------------------------------------------------
const.TOUCH = hash('touch')
const.R_TOUCH = hash('r_touch')
const.WUP = hash('wup')
const.WDOWN = hash('wdown')
-- --------------------------------------------------------
-- math
-- --------------------------------------------------------
const.RANDOM = math.random
const.FLOOR = math.floor
const.CEIL = math.ceil
const.MAX = math.max
const.MIN = math.min
const.EXP = math.exp
const.ABS = math.abs
const.RAD = math.rad
const.ATAN = math.atan
const.ATAN2 = math.atan2

-- --------------------------------------------------------
-- sys
-- --------------------------------------------------------
const.SYS_INFO = sys.get_sys_info()
const.CURRENT_SYSTEM_NAME = const.SYS_INFO.system_name
const.OS = {
	ANDROID = "Android",
	IOS = "iPhone OS",
	MAC = "Darwin",
	LINUX = "Linux",
	WINDOWS = "Windows",
	BROWSER = "HTML5",
}

return const