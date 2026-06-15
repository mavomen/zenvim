local dap = require("dap")
local dapui = require("dapui")
local map = vim.keymap.set

map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })

map("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional Breakpoint" })

map("n", "<leader>dL", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point: "))
end, { desc = "Log Point" })

map("n", "<leader>dr", dap.repl.open, { desc = "DAP REPL" })

map("n", "<leader>dl", dap.run_last, { desc = "Run Last Debug" })

map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

local function dap_python_safe(fn)
	return function()
		pcall(function()
			require("dap-python")[fn]()
		end)
	end
end

map("n", "<leader>dn", dap_python_safe("test_method"), { desc = "Debug nearest Python test method" })
map("n", "<leader>df", dap_python_safe("test_class"), { desc = "Debug nearest Python test class" })
map("v", "<leader>ds", dap_python_safe("debug_selection"), { desc = "Debug Python selection" })
