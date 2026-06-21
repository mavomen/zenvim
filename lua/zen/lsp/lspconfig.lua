local capabilities = require("zen.lsp.shared").capabilities

local servers = {
	"pyright",
	"csharp_ls",
	"rust_analyzer",
	"gopls",
	"ts_ls",
	"lua_ls",

	"cssls",
	"dockerls",
	"graphql",
	"html",
	"jsonls",
	"yamlls",

	"sqlls",
	"sqls",
	"postgres_lsp",
	"flux_lsp",
}

-- Registry of loaded extenders
local extenders = {}

-- Safe module setup helper
local function safe_setup(module_name, opts)
	local ok, mod = pcall(require, module_name)
	if not ok or type(mod) ~= "table" or type(mod.setup) ~= "function" then
		return
	end

	local setup_ok, err = pcall(mod.setup, opts)
	if not setup_ok then
		vim.schedule(function()
			vim.notify(string.format("Failed to setup %s: %s", module_name, err), vim.log.levels.ERROR)
		end)
	end
end

-- Resolve server configuration safely
local function resolve_server(server)
	local base = {
		capabilities = capabilities,
		on_attach = require("zen.lsp.shared").on_attach,
	}

	local ok, mod = pcall(require, "zen.lsp.servers." .. server)

	-- No module → fallback minimal config
	if not ok then
		return base
	end

	if type(mod) ~= "table" then
		vim.notify(string.format("[LSP] Server module '%s' did not return a table", server), vim.log.levels.ERROR)
		return base
	end

	-- Pattern A: module.setup()
	if type(mod.setup) == "function" then
		local ok_setup, err = pcall(mod.setup, capabilities)

		if not ok_setup then
			vim.notify(string.format("[LSP] setup() failed for %s: %s", server, err), vim.log.levels.ERROR)
		end

		if type(mod.extend) == "function" then
			extenders[server] = mod.extend
		end

		return nil
	end

	-- Pattern B: plain config table
	local opts = mod.config or mod

	if type(opts) ~= "table" then
		vim.notify(string.format("[LSP] Invalid config for %s (not a table)", server), vim.log.levels.ERROR)
		return base
	end

	opts = vim.tbl_deep_extend("force", base, opts)

	local original_on_attach = opts.on_attach

	opts.on_attach = function(client, bufnr)
		if original_on_attach then
			original_on_attach(client, bufnr)
		end

		if type(mod.extend) == "function" then
			mod.extend(client, bufnr)
		end
	end

	return opts
end

-- Unified loader
for _, server in ipairs(servers) do
	local config = resolve_server(server)

	if config then
		vim.lsp.config(server, config)
		vim.lsp.enable(server)
	end
end

-- Global extender dispatcher
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspExtenders", { clear = true }),
	desc = "Fire per-language extend() hooks",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		require("zen.lsp.shared").on_attach(client, args.buf)

		local ext = extenders[client.name]
		if ext then
			ext(client, args.buf)
		end
	end,
})

-- Optional modules
safe_setup("zen.lsp.symbol_index")
safe_setup("zen.lsp.diagnostics")
safe_setup("zen.lsp.progress")
safe_setup("zen.lsp.references")
safe_setup("zen.lsp.codelens")
safe_setup("zen.lsp.rename")
safe_setup("zen.lsp.code_actions")
safe_setup("zen.lsp.hover")
safe_setup("zen.lsp.inlay_hint")
safe_setup("zen.lsp.lightbulb", { debounce = 150 })
safe_setup("zen.lsp.semantic_tokens")
safe_setup("zen.lsp.virtual_text")
safe_setup("zen.lsp.workspace_symbol")
safe_setup("zen.lsp.implementation")
safe_setup("zen.lsp.type_definition")
safe_setup("zen.lsp.definition_peek")
safe_setup("zen.lsp.call_hierarchy")
safe_setup("zen.lsp.capability_inspector")
safe_setup("zen.lsp.toggle")
safe_setup("zen.lsp.info")
safe_setup("zen.lsp.analytics")
safe_setup("zen.lsp.keymaps")
