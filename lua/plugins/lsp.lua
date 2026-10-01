return {
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
				htmlangular = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
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
}
