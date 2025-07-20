-- plugin/cprunner.lua

-- Ensure the setup function is called, loading default values
-- if the user hasn't configured the plugin yet.
require("cprunner").setup({})

local config = require("cprunner.config")

-- Set the keymap only if the user hasn't disabled it.
if config.opts.setup_keymap then
	vim.keymap.set("n", config.opts.keymap, require("cprunner").run, {
		noremap = true,
		silent = true,
		desc = "Compile and run C/C++ file",
	})
end
