-- lua/cprunner/config.lua

local M = {}

-- This table holds the default configuration values.
M.defaults = {
	-- The compiler to use, e.g., "g++" or "clang++"
	compiler = "clang++",

	-- Compiler flags for C++ and C files
	cpp_flags = { "-std=c++17", "-Wall", "-Wextra", "-O2" },
	c_flags = { "-std=c11", "-Wall", "-Wextra", "-O2" },

	-- The name of the input file to look for
	input_filename = "input.txt",

	-- Whether to set up the default keymap automatically
	setup_keymap = true,

	-- The default keymap to run the function
	keymap = "<leader>r",
}

-- This table will be populated with the final merged configuration
-- (defaults + user options) by the setup() function.
M.opts = {}

return M
