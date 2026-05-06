local M = {
	clients = {},
	buffers = {},
}

function M.register(client, bufnr)
	M.clients[client.id] = client
	M.buffers[bufnr] = client.id
end

return M
