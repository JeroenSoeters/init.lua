return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    version = false,  -- Ignores lockfile for latest parsers (recommended on main)
    opts = {
        -- A list of parser names, or "all"
        ensure_installed = {
            "vimdoc", "javascript", "typescript", "c", "lua", "rust",
            "jsdoc", "bash", "go", "java", "kotlin", "pkl"
        },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,
        indent = {
            enable = true
        },
        highlight = {
            -- `false` will disable the whole extension
            enable = true,
            disable = function(lang, buf)
                if lang == "html" then
                    print("disabled")
                    return true
                end
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    vim.notify(
                        "File larger than 100KB treesitter disabled for performance",
                        vim.log.levels.WARN,
                        {title = "Treesitter"}
                    )
                    return true
                end
            end,
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = { "markdown" },
        },
        -- Custom parser configs (replaces the old treesitter_parser_config setup)
        parser_configs = {
            templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = {"src/parser.c", "src/scanner.c"},
                    branch = "main",
                },
            },
        },
    },
    config = function()
        -- Post-setup language registration (runs after opts are applied)
        vim.treesitter.language.register("templ", "templ")
        vim.treesitter.language.register("pkl", "pkl")
    end,
}
