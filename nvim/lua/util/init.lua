-- Small helpers shared across the config: require("util")
local M = {}

M.is_win = vim.fn.has("win32") == 1

return M
