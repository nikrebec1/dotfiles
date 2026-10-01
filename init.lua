-- ==========================================================================
-- 0. LEADER KEY (Must be set before plugins!!)
-- ==========================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.termguicolors = true
vim.env.CC = "C:/Users/nikre/zigcc.cmd"
vim.diagnostic.config({
	severity_sort = true, -- errors take priority over warnings
	underline = true,
	update_in_insert = false, -- don't flash errors while you're still typing
	virtual_text = false,
	virtual_lines = { current_line = true },
	-- virtual_text = {
	-- 	spacing = 2,
	-- 	source = "if_many", -- show which server reported it when there are several
	-- 	prefix = "●",
	-- },
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
	vim.o.clipboard = "unnamedplus"
end) -- Sync with Windows clipboard
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
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"vtsls",
				"lua_ls",
				"html",
				"cssls",
				"jsonls",
				"angularls",
				"jdtls",
				"tailwindcss",
				"eslint",
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = { "prettier", "stylua" },
		},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "super-tab" },
			signature = { enabled = true },

			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true } },
			},
			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"nvim-mini/mini.nvim",
		version = false,
		config = function()
			require("mini.ai").setup()
			require("mini.surround").setup()
			require("mini.pairs").setup()
			require("mini.diff").setup({
				view = { style = "sign" },
			})
		end,
	},
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		opts = {},
		keys = {
			{
				"<leader>sr",
				function()
					require("grug-far").open()
				end,
				desc = "Search and replace",
			},
		},
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore session",
			},
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			notifier = { enabled = true },
			explorer = { enabled = true },
			bigfile = { enabled = true },
			-- indent = { enabled = true },
			words = { enabled = true },
			input = { enabled = true },
			picker = {
				enabled = true,
				sources = {
					explorer = {
						layout = { layout = { position = "right" } },
					},
				},
			},
			-- lazygit = {
			-- 	config = {
			-- 		os = {
			-- 			edit = 'nvim --server "%NVIM%" --remote-send "q" && nvim --server "%NVIM%" --remote {{filename}}',
			-- 			editAtLine = 'nvim --server "%NVIM%" --remote-send "q" && nvim --server "%NVIM%" --remote {{filename}} && nvim --server "%NVIM%" --remote-send ":{{line}}<CR>"',
			-- 		},
			-- 	},
			-- },
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
				"<leader>/",
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
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"<leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"grr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gri",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Implementations",
			},
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Type definition",
			},
			{
				"gO",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "Document symbols",
			},
			{
				"]]",
				function()
					Snacks.words.jump(vim.v.count1)
				end,
				desc = "Next reference",
			},
			{
				"[[",
				function()
					Snacks.words.jump(-vim.v.count1)
				end,
				desc = "Previous reference",
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit.log()
				end,
				desc = "Git log",
			},
			{
				"<leader>gf",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "Current file history",
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			spec = {
				{ "<leader>o", group = "Obsidian" },
				{ "<leader>f", group = "Find" },
				{ "<leader>s", group = "Search" },
				{ "<leader>q", group = "Session" },
				{ "<leader>g", group = "Git" },
			},
		},
	},
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
				"typescript",
				"tsx",
				"java",
				"html",
				"dart",
				"markdown",
				"markdown_inline",
				"angular",
				"json",
				"scss",
				"css",
				"bash",
				"yaml",
			})
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					if not pcall(vim.treesitter.start) then
						return
					end
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
				end,
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				htmlangular = { "prettier" },
			},
		},
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ async = true })
				end,
				desc = "Format buffer",
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		opts = {
			signs = false,
		},
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = 20,
			open_mapping = [[<C-t>]],
			direction = "float",
			float_opts = { border = "curved" },
			shell = "C:/PROGRA~1/Git/bin/bash.exe",
		},
	},
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			options = { globalstatus = true },
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{
				"<C-f>",
				function()
					if not require("noice.lsp").scroll(4) then
						return "<C-f>"
					end
				end,
				mode = { "n", "i", "s" },
				expr = true,
				silent = true,
				desc = "Scroll down in hover",
			},
			{
				"<C-b>",
				function()
					if not require("noice.lsp").scroll(-4) then
						return "<C-b>"
					end
				end,
				mode = { "n", "i", "s" },
				expr = true,
				silent = true,
				desc = "Scroll up in hover",
			},
		},
		opts = {
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
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
			style = "night",
			on_colors = function(c)
				c.bg = "#161b2e"
				c.bg_dark = "#111524"
				c.bg_float = "#111524"
				c.bg_sidebar = "#111524"
				c.bg_highlight = "#262e4a"
			end,
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
	{ "tadaa/vimade", event = "VeryLazy", opts = { fadelevel = 0.6 } },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
})

-- ==========================================================================
-- 4. PLUGIN CONFIGURATION & KEYMAPS
-- ==========================================================================
vim.lsp.enable("dartls")
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

-- Safety Switch: Esc to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
