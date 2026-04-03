-- Options
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.scrolloff = 20
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"
vim.o.winborder = "rounded"

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		for _, a in ipairs(vim.v.argv) do
			if a:match("^%+.+") then
				return
			end
		end
		if vim.fn.argc() == 0 then
			vim.schedule(function()
				require("oil").open(vim.fn.getcwd(), {
					preview = {
						vertical = true,
						split = "botright",
					},
				})
			end)
		end
	end,
})

local pack = vim.pack.add

-- Keymap Settings
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "

-- Regular Keymaps
map("i", "jk", "<esc>", opts)
map("n", "<leader>nh", ":nohl<CR>", opts)
map("n", "<leader>rn", vim.lsp.buf.rename, opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>wa", ":wa<CR>", opts)
map("n", "<leader>gd", ":lua vim.lsp.buf.definition()<CR>", opts)
map("n", "<leader>gb", "<C-^>", opts)
vim.cmd("packadd nvim.undotree")
map("n", "<leader>ut", function()
	require("undotree").open({
		command = "60vnew",
	})
end, opts)

-- Icons
pack({ "https://github.com/nvim-tree/nvim-web-devicons" })

-- Oil setup TODO: i would like to configure this a little more
pack({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup({
	watch_for_changes = true,
	view_options = {
		show_hidden = true,
	},
})

-- Oil Keymaps
map("n", "<leader>e", function()
	require("oil").open(nil, {
		preview = {
			vertical = true,
			split = "botright",
		},
	})
end, opts)

-- Autopairs & Autotag setup
pack({
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/windwp/nvim-ts-autotag",
})
require("nvim-autopairs").setup()
require("nvim-ts-autotag").setup()

--Treesitter setup
pack({ "https://github.com/nvim-treesitter/nvim-treesitter" })
require("nvim-treesitter").install({
	"rust",
	"javascript",
	"bash",
	"c",
	"dockerfile",
	"dot",
	"editorconfig",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"html",
	"json",
	"lua",
	"markdown",
	"python",
	"sql",
	"ssh_config",
	"swift",
	"tmux",
})

-- LSP & Mason config setup
pack({ "https://github.com/neovim/nvim-lspconfig" })
-- Mason setup
pack({ "https://github.com/mason-org/mason.nvim" })
require("mason").setup()

pack({ "https://github.com/mason-org/mason-lspconfig.nvim" })
require("mason-lspconfig").setup()

-- Telescope setup
pack({
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
})
require("telescope").setup()
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fc", builtin.grep_string)
vim.keymap.set("n", "<leader>fm", builtin.marks)
vim.keymap.set("n", "<leader>faf", builtin.treesitter)
vim.keymap.set("n", "<leader>fr", builtin.oldfiles)

-- Color picker
pack({ "https://github.com/mofiqul/dracula.nvim" })
vim.cmd([[colorscheme dracula]])

-- Git Signs
pack({ "https://github.com/lewis6991/gitsigns.nvim" })

-- Lualine
pack({ "https://github.com/nvim-lualine/lualine.nvim" })
require("lualine").setup({
	theme = "dracula",
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{
				"filename",
				path = 3,
				shorting_target = 40,
			},
		},
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

-- cmp - completion engine
pack({
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/saghen/blink.cmp",
})
require("blink.cmp").setup({
	keymap = {
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<Tab>"] = { "select_and_accept", "fallback" },
	},
	completion = {
		menu = {
			border = "rounded",
			auto_show = true,
		},
		documentation = {
			auto_show = true,
			window = { border = "rounded" },
		},
		list = {
			selection = { preselect = true, auto_insert = true },
		},
	},
})

-- Formatter setup
pack({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		rust = { "rustfmt" },
		javascript = { "prettierd" },
		go = { "gofmt" },
	},
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- Trouble setup
pack({ "https://github.com/folke/trouble.nvim" })
require("trouble").setup()

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")

-- Todo-Comments
pack({ "https://github.com/folke/todo-comments.nvim" })
require("todo-comments").setup()

map("n", "<leader>cc", "<cmd>Trouble todo toggle<cr>", opts)
map("n", "<leader>fc", "<cmd>TodoTelescope<cr>", opts)

-- Markdown renderer
vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
})
require("render-markdown").setup({})

-- Surround setup
pack({ "https://github.com/kylechui/nvim-surround" })

-- Harpoon setup
pack({
	"https://github.com/nvim-lua/plenary.nvim",
	{
		src = "https://github.com/ThePrimeagen/harpoon",
		version = "harpoon2",
	},
})

local harpoon = require("harpoon")
harpoon:setup()

map("n", "<leader>ha", function()
	harpoon:list():add()
end)

map("n", "<leader>hl", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

map("n", "<leader>1", function()
	harpoon:list():select(1)
end)

map("n", "<leader>2", function()
	harpoon:list():select(2)
end)

map("n", "<leader>3", function()
	harpoon:list():select(3)
end)

map("n", "<leader>4", function()
	harpoon:list():select(4)
end)

map("n", "<leader>5", function()
	harpoon:list():select(5)
end)

-- Folder setup

-- Lazygit setup
pack({ "https://github.com/kdheepak/lazygit.nvim" })
map("n", "<leader>lg", "<cmd>LazyGit<cr>", opts)
