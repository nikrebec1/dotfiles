local util = require("util")

-- Leader (must be set before plugins load)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Windows-only: zig as the C compiler for treesitter parsers
if util.is_win then
	vim.env.CC = "C:/Users/nikre/zigcc.cmd"
end

-- Editor
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true -- Relative numbers for jumping
vim.o.ignorecase = true -- Ignore case when searching...
vim.o.smartcase = true -- ...unless you type a capital
vim.o.undofile = true -- Persistent undo (works after restart)
vim.o.tabstop = 4 -- 4 spaces for tabs
vim.o.shiftwidth = 4
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.grepprg = "rg --vimgrep --smart-case"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.signcolumn = "yes"
vim.o.scrolloff = 8
vim.o.cursorline = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 250
vim.o.inccommand = "split" -- live preview of :s
vim.o.breakindent = true
vim.o.confirm = true -- ask instead of failing on :q with unsaved changes
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.fileformats = "unix,dos"
vim.schedule(function()
	vim.o.clipboard = "unnamedplus" -- Sync with system clipboard
end)

-- Diagnostics
vim.diagnostic.config({
	severity_sort = true, -- errors take priority over warnings
	underline = true,
	update_in_insert = false, -- don't flash errors while you're still typing
	virtual_text = false,
	virtual_lines = { current_line = true },
	float = {
		border = "rounded",
		source = "if_many",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
})
