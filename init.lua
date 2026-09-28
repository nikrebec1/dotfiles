-- ==========================================================================
-- 0. LEADER KEY (Must be set before plugins!)
-- ==========================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true
-- vim.cmd.highlight({ "Normal", "guibg=NONE" })
vim.env.CC = "C:/Users/nikre/zigcc.cmd"
--: vim.api.nvim_set_hl(0, "Normal", { bg = "#042730" })
-- ==========================================================================
-- 2. LAZY.NVIM BOOTSTRAP
-- ==========================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================================================
-- 3. PLUGINS (The Standard Set)
-- ==========================================================================
require("lazy").setup({
	{ import = "plugins" },
	-- Terminal Toggle
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},
	{ "nvim-mini/mini.nvim", version = false },
	{
		"MagicDuck/grug-far.nvim",
		opts = {},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			picker = {
				enabled = true,
				sources = {
					explorer = {
						layout = { layout = { position = "right" } },
					},
				},
			},
			explorer = {
				enabled = true,
			},
		},
		keys = {
			{
				"<leader><space>",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Find Text",
			},
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Find Buffers",
			},
			{
				"<leader>fc",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
		},
	},
	-- Which-Key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	-- Syntax Highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"javascript",
				"java",
				"html",
				"dart",
				"typescript",
				"markdown",
				"markdown_inline",
				"angular",
			})
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
	-- Conform
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				htmlangular = { "prettier" },
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = { globalstatus = true },
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify", -- optional, for nicer notification popups
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			presets = {
				bottom_search = true, -- keep / and ? searches at the bottom
				command_palette = false, -- cmdline and completion menu together at the top
				long_message_to_split = true, -- long messages open in a split
				lsp_doc_border = true, -- borders on hover and signature help
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			dim_inactive = true,
			style = "night",
			on_highlights = function(hl, c)
				hl.LineNr = { fg = "#2d5a63", bold = true }
				hl.WinSeparator = { fg = c.border_highlight, bg = c.bg }
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{ "tadaa/vimade", event = "VeryLazy", opts = { fadelevel = 0.7 } },
	{ "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
	{ "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
	{ "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },
	{ "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },
})

-- ==========================================================================
-- 4. PLUGIN CONFIGURATION & KEYMAPS
-- ==========================================================================
require("lualine").setup()
-- ToggleTerm Config
require("toggleterm").setup({
	size = 20,
	open_mapping = [[<C-t>]], -- Ctrl+t to toggle
	direction = "float",
	float_opts = { border = "curved" },
	shell = "C:/PROGRA~1/Git/bin/bash.exe",
})
local map = vim.keymap.set
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map(
	"v",
	"<A-j>",
	":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",
	{ desc = "Move selection down", silent = true }
)
map(
	"v",
	"<A-k>",
	":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv",
	{ desc = "Move selection up", silent = true }
)
-- ==========================================================================
-- 5. STANDARD OPTIONS (The "Must Haves")
-- ==========================================================================
vim.opt.number = true
vim.opt.relativenumber = true -- Relative numbers for jumping
vim.opt.ignorecase = true -- Ignore case when searching...
vim.opt.smartcase = true -- ...unless you type a capital
vim.opt.undofile = true -- Persistent undo (works after restart)
vim.opt.tabstop = 4 -- 4 spaces for tabs
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.wildmenu = true
vim.opt.wildmode = "noselect:lastused,full"
vim.opt.wildoptions = "pum,fuzzy"
vim.opt.pumheight = 15 -- max items shown in the popup
vim.api.nvim_create_autocmd("CmdlineChanged", {
	pattern = { ":", "/", "?" },
	callback = function()
		vim.fn.wildtrigger()
	end,
})
vim.keymap.set("c", "<Up>", function()
	return vim.fn.wildmenumode() == 1 and "<C-e><Up>" or "<Up>"
end, { expr = true })

vim.keymap.set("c", "<Down>", function()
	return vim.fn.wildmenumode() == 1 and "<C-e><Down>" or "<Down>"
end, { expr = true })

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end) -- Sync with Windows clipboard
-- Safety Switch: Esc to exit terminal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>fm", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.conceallevel = 2
	end,
})
