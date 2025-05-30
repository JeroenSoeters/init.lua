return {
    "apple/pkl-neovim",
    lazy = true,
    ft = "pkl",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter",
            build = function(_)
                vim.cmd("TSUpdate")
            end,
        },
        "L3MON4D3/LuaSnip",
    },
    init = function()
        -- Set configuration as early as possible
        vim.env.JAVA_HOME = "/home/jeroen/.sdkman/candidates/java/current"
        vim.env.PATH = "/home/jeroen/.sdkman/candidates/java/current/bin:" .. vim.env.PATH

        vim.g.pkl_neovim = {
            start_command = { "/home/jeroen/.sdkman/candidates/java/current/bin/java", "-jar", "/home/jeroen/.local/share/pkl-lsp/pkl-lsp-0.3.2.jar" },
        }
    end,
    build = function()
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.pkl = {
            install_info = {
                url = "https://github.com/apple/tree-sitter-pkl",
                files = {"src/parser.c", "src/scanner.c"},
                branch = "main",
                generate_requires_npm = false,
                requires_generate_from_grammar = false,
            },
            filetype = "pkl",
        }
        vim.cmd("TSInstall pkl")
    end,
    config = function()
        require('pkl-neovim').init()
        require("luasnip.loaders.from_snipmate").lazy_load()
    end,
}
