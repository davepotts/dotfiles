local dap, dapui = require("dap"), require("dapui")
local cmp = require('cmp')
local ts_utils = require("nvim-treesitter").ts_utils
local remap = require("davepotts.utils").remap

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

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

require("nvim-dap-virtual-text").setup()

local function find_node_by_type(expr, type_name)
	while expr do
		if expr:type() == type_name then
			break
		end
		expr = expr:parent()
	end
	return expr
end

local function find_child_by_type(expr, type_name)
	local id = 0
	local expr_child = expr:child(id)
	while expr_child do
		if expr_child:type() == type_name then
			break
		end
		id = id + 1
		expr_child = expr:child(id)
	end

	return expr_child
end

function get_current_method_name()
	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then return nil end

	local expr = find_node_by_type(current_node, 'method_declaration')
	if not expr then return nil end

	local child = find_child_by_type(expr, 'identifier')
	if not child then return nil end
	return vim.treesitter.query.get_node_text(child, 0)
end

function get_current_class_name()
	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then return nil end

	local class_declaration = find_node_by_type(current_node, 'class_declaration')
	if not class_declaration then return nil end

	local child = find_child_by_type(class_declaration, 'identifier')
	if not child then return nil end
	return vim.treesitter.query.get_node_text(child, 0)
end

function get_current_package_name()
	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then return nil end

	local program_expr = find_node_by_type(current_node, 'program')
	if not program_expr then return nil end
	local package_expr = find_child_by_type(program_expr, 'package_declaration')
	if not package_expr then return nil end

	local child = find_child_by_type(package_expr, 'scoped_identifier')
	if not child then return nil end
	return vim.treesitter.query.get_node_text(child, 0)
end

function get_current_full_class_name()
	local package = get_current_package_name()
	local class = get_current_class_name()
	return package .. '.' .. class
end

function get_current_full_method_name(delimiter)
	delimiter = delimiter or '.'
	local full_class_name = get_current_full_class_name()
	local method_name = get_current_method_name()
	return full_class_name .. delimiter .. method_name
end

function get_test_runner(test_name, debug)
	if debug then
		return 'mvn test -Dmaven.surefire.debug -Dtest="' .. test_name .. '"'
	end
	return 'mvn test -Dtest="' .. test_name .. '"'
end

function run_java_test_method(debug)
	local method_name = get_current_full_method_name("\\#")
	vim.cmd('term ' .. get_test_runner(method_name, debug))
end

function run_java_test_class(debug)
	local class_name = get_current_full_class_name()
	vim.cmd('term ' .. get_test_runner(class_name, debug))
end

function get_spring_boot_runner(profile, debug)
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

function run_spring_boot(profile, debug)
	vim.cmd('term ' .. get_spring_boot_runner(profile, debug))
end

dap.configurations.java = {
	{
		type = 'java',
		request = 'attach',
		name = "Attach to the process",
		hostName = 'localhost',
		port = '5005',
	},
}

dap.adapters.firefox = {
	type = "executable",
	command = "node",
	args = { "/opt/vscode-firefox-debug/dist/adapter.bundle.js" }
}

dap.configurations.typescript = {
	{
		name = "Attach Firefox",
		type = "firefox",
		request = "attach",
		reAttach = true,
		url = "http://localhost:4600",
		webRoot = "${workspaceFolder}",
		firefoxExecutable = '/usr/bin/firefox',
		firefoxArgs = {"-P 'default'"}
	},{
		name = "Debug with Firefox",
		type = "firefox",
		request = "launch",
		reAttach = true,
		url = "http://localhost:4600",
		webRoot = "${workspaceFolder}",
		firefoxExecutable = '/usr/bin/firefox',
		firefoxArgs = {"--no-remote -P 'debug_profile'"},
		tmpDir = "/mnt/c/Users/Dave.Potts/"
	} }

function attach_to_debug()
	continue()
end

function show_dap_centered_scopes()
	local widgets = require 'dap.ui.widgets'
	widgets.centered_float(widgets.scopes)
end

function continue()
	dap.continue()
end

function step_over()
	dap.step_over()
end

function step_into()
	dap.step_into()
end

function step_out()
	dap.step_out()
end

function toggle_breakpoint()
	dap.toggle_breakpoint()
end

function conditional_breakpoint()
	dap.set_breakpoint(vim.fn.input("condition: "))
end

function log_breakpoint()
	dap.set_breakpoint(nil, nil, vim.fn.input("log: "))
end

function open_repl()
	dap.repl.open()
end

--remap("n", "<leader>r", ":lua run_spring_boot('local', false)<CR>")
--remap("n", "<leader>d", ":lua run_spring_boot('local', true)<CR>")
remap('n', '<leader>dc', ':lua continue()<CR>')
remap('n', '<leader>do', ':lua step_over()<CR>')
remap('n', '<F7>', ':lua step_into()<CR>')
remap('n', '<S-F8>', ':lua step_out()<CR>')

remap("n", "<leader>tm", ":lua run_java_test_method()")
remap("n", "<leader>TM", ":lua run_java_test_method(true)")
remap("n", "<leader>tc", ":lua run_java_test_class()")
remap("n", "<leader>TC", ":lua run_java_test_class(true)")

remap('n', '<leader>b', ':lua toggle_breakpoint()<CR>')
remap('n', '<leader>B', ':lua set_breakpoint(vim.fn.input("Condition: "))<CR>')
remap('n', '<leader>bl', ':lua set_breakpoint(nil, nil, vim.fn.input("Log: "))<CR>')
remap('n', 'gs', ':lua show_dap_centered_scopes()<CR>')
