

local typescript_format_on_save = vim.api.nvim_create_augroup("typescript_format_on_save", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = typescript_format_on_save,
	buffer = 0,
	callback = function()
local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }

		vim.lsp.buf.format()
    -- perform a syncronous request
    -- 500ms timeout depending on the size of file a bigger timeout may be needed
    print(vim.lsp.buf_request_sync(vim.api.nvim_get_current_buf(), "workspace/executeCommand", params, 500))
end
})
