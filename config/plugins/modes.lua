require('modes').setup({
	colors = {
		copy = "#edb000",
		delete = "#D30044",
		insert = "#731da2",
		visual = "#78ccc5",
	},

	-- Set opacity for cursorline and number background
	line_opacity = 0.15,

	-- Enable cursor highlights
	set_cursor = true,

	-- Enable cursorline initially, and disable cursorline for inactive windows
	-- or ignored filetypes
	set_cursorline = true,

	-- Enable line number highlights to match cursorline
	set_number = true,

	-- Disable modes highlights in specified filetypes
	-- Please PR commonly ignored filetypes
	ignore_filetypes = { 'NvimTree', 'TelescopePrompt' }
})
