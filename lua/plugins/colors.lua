function ColorMyPencils(color)
    color = color or "rose-pine" -- Default to rose-pine
    vim.cmd.colorscheme(color)
end

return {
    -- If you're not using Brightburn, you can remove this.
    {
        "erikbackman/brightburn.vim",
    },

    -- Remove the duplicate Tokyonight entry.
    -- If you want to use Tokyonight, configure it like this:
    {
        "folke/tokyonight.nvim",
        lazy = false, -- Load at startup
        opts = {
            style = "storm",
            transparent = true,
            terminal_colors = true,
            styles = {
                comments = { italic = false },
                keywords = { italic = false },
                sidebars = "dark",
                floats = "dark",
            },
        },
        -- No `config` function just for ColorMyPencils.
        -- If you wanted Tokyonight to be your default, you'd put
        -- vim.cmd("colorscheme tokyonight") in an `init` block or main init.lua.
    },

    -- If you're not using Gruvbox, you can remove this.
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox", -- Important if the repo name doesn't match the colorscheme name
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true,
                contrast = "",
                palette_overrides = {},
                overrides = {},
                dim_inactive = false, -- Gruvbox also has this, good to keep.
                transparent_mode = false,
            })
        end,
        -- No `init` here, as you're primarily aiming for rose-pine.
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                variant = 'moon',
                disable_background = true,
                styles = {
                    italic = false,
                },
                dim_inactive = false,
            })

            -- Set the colorscheme
            vim.cmd("colorscheme rose-pine")

            -- Set up the autocmd after colorscheme is loaded
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                    vim.api.nvim_set_hl(0, "NormalNC", { link = "Normal" })
                    -- Keep the dap-ui fixes
                    vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
                    vim.api.nvim_set_hl(0, "WinBarNC", { link = "Normal" })
                    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
                    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
                    -- Make Telescope borders match
                    vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "Normal" })
                    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { link = "Normal" })
                    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { link = "Normal" })
                    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { link = "Normal" })
                end,
            })

            -- Apply immediately
            vim.api.nvim_set_hl(0, "NormalNC", { link = "Normal" })
            vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
            vim.api.nvim_set_hl(0, "WinBarNC", { link = "Normal" })
            vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
            vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
            vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "Normal" })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", { link = "Normal" })
            vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { link = "Normal" })
            vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { link = "Normal" })
        end,
    }
}
