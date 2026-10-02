-- Order matters: options sets the leader key, which must happen before lazy loads plugins
require("config.options")
require("config.lazy")
require("config.keymaps")

vim.lsp.enable("dartls")
