-- General keymaps. Plugin keymaps live in their plugin spec's `keys`.
local map = vim.keymap.set

-- Move lines
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

-- Misc
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
