-- Note IDs: 202610010904-my-note-title
local function note_id(title)
	local id = os.date("%Y%m%d%H%M")
	if not title or title == "" then
		return id
	end
	local slug = title:lower():gsub('[\\/:*?"<>|]', ""):gsub("%s+", "-")
	return id .. "-" .. slug
end

return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	ft = "markdown",
	cmd = "Obsidian",
	keys = {
		{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
		{ "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
		{ "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
		{ "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
		{ "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "Tags" },
		{ "<leader>od", "<cmd>Obsidian today<cr>", desc = "New daily template" },
		{ "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's daily template" },
		{ "<leader>or", "<cmd>Obsidian tomorrow<cr>", desc = "Tomorrow's daily template" },
	},
	opts = {
		legacy_commands = false,
		workspaces = {
			{ name = "Mind Palace", path = "~/vaults/Mind Palace" },
		},
		picker = { name = "snacks.picker" },
		sync = { enabled = true },
		notes_subdir = "notes",
		new_notes_location = "notes_subdir",
		templates = { folder = "templates" },
		note = { template = "zettel-template.md" },
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			template = "daily-template.md",
			default_tags = { "todo" },
		},
		note_id_func = note_id,
	},
}
