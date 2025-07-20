-- lua/cprunner/init.lua

local config = require("cprunner.config")

local M = {}

-- The setup function merges user-provided options with the defaults.
-- This is the main entry point for configuring the plugin.
function M.setup(user_opts)
	-- The 'force' option ensures deep merging of tables
	config.opts = vim.tbl_deep_extend("force", config.defaults, user_opts or {})
end

-- The main function to compile and run the code.
function M.run()
	-- --- 1. Get File Details ---
	local current_file = vim.fn.expand("%:p")
	local extension = vim.fn.expand("%:e")

	local flags
	if extension == "cpp" then
		flags = config.opts.cpp_flags
	elseif extension == "c" then
		flags = config.opts.c_flags
	else
		vim.notify("Not a C/C++ file!", vim.log.levels.WARN)
		return
	end

	local executable_file = vim.fn.expand("%:p:r")
	local project_dir = vim.fn.expand("%:p:h")
	local input_file = project_dir .. "/" .. config.opts.input_filename

	-- --- 2. Save and Compile ---
	vim.cmd("w") -- Save the current buffer

	local compile_command_parts = { config.opts.compiler }
	vim.list_extend(compile_command_parts, flags)
	vim.list_extend(compile_command_parts, { "-o", executable_file, current_file })

	local compile_command = table.concat(compile_command_parts, " ")
	local compiler_output = vim.fn.system(compile_command)

	if vim.v.shell_error ~= 0 then
		vim.notify("❌ Compilation Failed", vim.log.levels.ERROR)
		print("Compiler Errors:\n" .. compiler_output)
		return
	end

	vim.notify("✅ Compilation Successful", vim.log.levels.INFO)

	-- --- 3. Window Management ---
	-- Close any previous runner terminal or input file window
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.b[buf].is_runner_terminal or vim.api.nvim_buf_get_name(buf):match(config.opts.input_filename .. "$") then
			vim.api.nvim_win_close(win, true)
		end
	end

	-- Create new layout
	vim.cmd("vsplit " .. vim.fn.fnameescape(input_file))
	vim.cmd("wincmd l") -- Move to the right window (the new input file)
	vim.cmd("split") -- Split it horizontally for the terminal

	-- --- 4. Prepare and Run Command ---
	local terminal_command
	if vim.fn.getfsize(input_file) > 0 then
		-- Input file has content: run with redirection and wait
		local run_cmd = vim.fn.shellescape(executable_file) .. " < " .. vim.fn.shellescape(input_file)
		local wait_cmd = 'read -k -s "?[Program finished. Press any key to close...]"'
		terminal_command = run_cmd .. "; " .. wait_cmd
	else
		-- Input file is empty: run interactively
		terminal_command = vim.fn.shellescape(executable_file)
	end

	vim.cmd("terminal " .. terminal_command)
	vim.b.is_runner_terminal = true -- Mark the terminal buffer

	vim.cmd("wincmd p") -- Move focus back to the original code window
end

return M
