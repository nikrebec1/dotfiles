return {
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
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
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
		dependencies = { "MunifTanjim/nui.nvim" },
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
				bottom_search = true,
				command_palette = false,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
	},
	{ "tadaa/vimade", event = "VeryLazy", opts = { fadelevel = 0.6 } },
}
