local cmp = require('cmp')
local utils = require("davepotts.utils").treesitter

cmp.setup({
	enabled = function()
		return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
				or require("cmp_dap").is_dap_buffer()
	end
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	sources = {
		{ name = "dap" },
	},
})

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

local function get_test_runner(test_name, debug)
	if debug then
		return 'mvn test -Dmaven.surefire.debug -Dtest="' .. test_name .. '"'
	end
	return 'mvn test -Dtest="' .. test_name .. '"'
end

local function run_java_test_method(debug)
	local method_name = utils.get_current_full_method_name("\\#")
	vim.cmd('term ' .. get_test_runner(method_name, debug))
end

local function run_java_test_class(debug)
	local class_name = utils.get_current_full_class_name()
	vim.cmd('term ' .. get_test_runner(class_name, debug))
end

local function get_spring_boot_runner(profile, debug)
	local debug_param = ""
	if debug then
		debug_param =
		' -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005" '
	end

	local profile_param = ""
	if profile then
		profile_param = " -Dspring-boot.run.profiles=" .. profile .. " "
	end

	return 'mvn spring-boot:run ' .. profile_param .. debug_param
end

local function run_spring_boot(profile, debug)
	vim.cmd('term ' .. get_spring_boot_runner(profile, debug))
end

local function attach_to_debug()
	local dap = require('dap')
	dap.configurations.java = {
		{
			type = 'java',
			request = 'attach',
			name = "Attach to the process",
			hostName = 'localhost',
			port = '5005',
		},
	}
	dap.continue()
end

local function show_dap_centered_scopes()
	local widgets = require 'dap.ui.widgets'
	widgets.centered_float(widgets.scopes)
end

local remap = function(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

remap("n", "<F9>", ":lua run_spring_boot(nil, false)")
remap("n", "<F10>", ":lua run_spring_boot(nil, true)")
remap('n', '<F5>', ':lua require"dap".continue()<CR>')
remap('n', '<F8>', ':lua require"dap".step_over()<CR>')
remap('n', '<F7>', ':lua require"dap".step_into()<CR>')
remap('n', '<S-F8>', ':lua require"dap".step_out()<CR>')

remap("n", "<leader>tm", ":lua run_java_test_method()")
remap("n", "<leader>TM", ":lua run_java_test_method(true)")
remap("n", "<leader>tc", ":lua run_java_test_class()")
remap("n", "<leader>TC", ":lua run_java_test_class(true)")

remap('n', '<leader>b', ':lua require"dap".toggle_breakpoint()<CR>')
remap('n', '<leader>B', ':lua require"dap".set_breakpoint(vim.fn.input("Condition: "))<CR>')
remap('n', '<leader>bl', ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log: "))<CR>')
remap('n', '<leader>dr', ':lua require"dap".repl.open()<CR>')

remap('n', 'gs', ':lua show_dap_centered_scopes()<CR>')
remap('n', '<leader>da', ':lua attach_to_debug()<CR>')
