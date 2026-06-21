local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Files / misc
------------------------------------------------------------
map("n", "<leader>x", function()
	local word = vim.fn.expand("<cword>")
	if word == "" then
		vim.notify("No word under cursor", vim.log.levels.WARN)
		return
	end
	vim.api.nvim_feedkeys(
		":%s/"
			.. vim.fn.escape(word, "/\\")
			.. "//gc"
			.. string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), 3),
		"n",
		false
	)
end, { desc = "Replace word under cursor interactively" })

map("n", "<leader>pv", "<cmd>Oil<CR>", { desc = "Open Oil" })

vim.keymap.set("i", "jk", "<esc>")

map("n", "<leader>foo", function()
	require("oil").open(vim.fn.getcwd())
end, { desc = "Open Oil in cwd" })

map("n", "<leader>nf", function()
	if vim.bo.filetype ~= "oil" then
		return vim.notify("Not in oil buffer", vim.log.levels.WARN)
	end
	vim.ui.input({ prompt = "New file name: " }, function(input)
		if not input or input == "" then
			return
		end
		local dir = require("oil").get_current_dir()
		if not dir then
			return vim.notify("Could not determine Oil directory", vim.log.levels.ERROR)
		end
		local sep = dir:sub(-1) == "/" and "" or "/"
		local path = dir .. sep .. input
		vim.cmd("edit " .. vim.fn.fnameescape(path))
	end)
end, { desc = "Create new file in Oil" })

map("n", "<leader>nd", function()
	if vim.bo.filetype ~= "oil" then
		return vim.notify("Not in oil buffer", vim.log.levels.WARN)
	end
	vim.ui.input({ prompt = "New directory name: " }, function(input)
		if not input or input == "" then
			return
		end
		local dir = require("oil").get_current_dir()
		if not dir then
			return vim.notify("Could not determine Oil directory", vim.log.levels.ERROR)
		end
		local sep = dir:sub(-1) == "/" and "" or "/"
		local path = dir .. sep .. input
		vim.fn.mkdir(path, "p")
		require("oil").open(dir)
	end)
end, { desc = "Create new directory in Oil" })

-- Surround (manual, no plugin)
------------------------------------------------------------
local surrounds = {
	["("] = "()",
	["["] = "[]",
	["{"] = "{}",
	['"'] = '""',
	["'"] = "''",
	["*"] = "**",
	["<"] = "<>",
}

for k, pair in pairs(surrounds) do
	map("n", "<leader>g" .. k, "ciw" .. pair .. "<Esc>P", { desc = "Surround word with " .. pair })
	map("v", "<leader>g" .. k, "c" .. pair .. "<Esc>P", { desc = "Surround selection with " .. pair })
end

-- Save / session
------------------------------------------------------------
map("n", "<leader>;w", function()
	vim.cmd("wall")
	local filetype = vim.bo.filetype
	if filetype == "lua" then
		vim.cmd("source %")
		vim.notify(" 󱓎 ", vim.log.levels.INFO)
	else
		vim.notify(" 󱓎 ", vim.log.levels.INFO)
	end
	vim.cmd("mkview")
end, { desc = "Save all; source if Lua" })

map("n", "<leader>;z", "ZZ", opts)
