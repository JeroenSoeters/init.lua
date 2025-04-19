return {
	"vim-autoformat/vim-autoformat",
	config = function()
		vim.api.nvim_create_autocmd({"BufWrite"}, {
			pattern = { "*" },
			command = ":Autoformat"
		})
	end
}
