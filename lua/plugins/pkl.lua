return {
    config = function()
        -- Filetype autocmd for .pkl (from the old plugin)
        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            pattern = "*.pkl",
            callback = function()
                vim.bo.filetype = "pkl"
            end,
        })

        -- Syntax highlights (Treesitter @captures, linked to base groups—exact from plugin)
        local hl = vim.api.nvim_set_hl
        hl(0, "@variable", { link = "Identifier" })
        hl(0, "@variable.property", { link = "Identifier" })
        hl(0, "@field", { link = "Identifier" })
        hl(0, "@property", { link = "Identifier" })
        hl(0, "@method", { link = "Function" })
        hl(0, "@method.call", { link = "Function" })
        hl(0, "@constructor", {})
        hl(0, "@parameter", { link = "Identifier" })
        hl(0, "@keyword.operator", { link = "Operator" })
        hl(0, "@keyword", { link = "Keyword" })
        hl(0, "@keyword.function", { link = "Keyword" })
        hl(0, "@keyword.return", { link = "Keyword" })
        hl(0, "@constant.builtin", { link = "Constant" })
        hl(0, "@constant", { link = "Constant" })
        hl(0, "@string", { link = "String" })
        hl(0, "@string.regex", { link = "String" })
        hl(0, "@string.escape", { link = "SpecialChar" })
        hl(0, "@character", { link = "Character" })
        hl(0, "@comment", { link = "Comment" })
        hl(0, "@punctuation.bracket", { link = "Delimiter" })
        hl(0, "@punctuation.delimiter", { link = "Delimiter" })
        hl(0, "@punctuation.special", { link = "Delimiter" })
        hl(0, "@number", { link = "Number" })
        hl(0, "@boolean", { link = "Boolean" })
        hl(0, "@float", { link = "Float" })
        hl(0, "@function", { link = "Function" })
        hl(0, "@function.call", { link = "Function" })
        hl(0, "@function.builtin", { link = "Special" })
        hl(0, "@function.macro", { link = "Macro" })
        hl(0, "@type", { link = "Type" })
        hl(0, "@type.builtin", { link = "Type" })
        hl(0, "@type.definition", { link = "Type" })
        hl(0, "@type.qualifier", { link = "Special" })
        hl(0, "@include", { link = "Include" })
        hl(0, "@text.title", { link = "Title" })
        hl(0, "@text.literal", { link = "String" })
        hl(0, "@text.uri", { link = "Underlined" })
        hl(0, "@tag", { link = "Tag" })
        hl(0, "@tag.attribute", { link = "Special" })
        hl(0, "@tag.delimiter", { link = "Delimiter" })
        hl(0, "@error", { link = "Error" })
        hl(0, "@todo", { link = "Todo" })

        -- Indent rules (from plugin's vim.g.pkl_indent—basic for Pkl's block structure)
        vim.g.pkl_indent = {
            keywords = { "if", "else", "for", "while", "class", "extension", "function", "property", "secret" },
            increase = 1,
            -- Add more rules if needed (e.g., for braces/keywords)
        }

        -- Optional: If you use an indent plugin like nvim-ts-autotag or custom, hook it here
    end,
}
