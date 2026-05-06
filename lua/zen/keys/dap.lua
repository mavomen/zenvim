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

map("n", "<leader>dn", function()
	require("dap-python").test_method()
end)

map("n", "<leader>df", function()
	require("dap-python").test_class()
end)

map("v", "<leader>ds", function()
	require("dap-python").debug_selection()
end)
