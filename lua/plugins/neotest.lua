return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            { "fredrikaverpil/neotest-golang", version = "*",
                dependencies = {
                    "leoluz/nvim-dap-go",
                }, -- Installation
            },
        },
        keys = {
            { "<leader>ta", function() require("neotest").run.attach() end, desc = "[t]est [a]ttach" },
            { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "[t]est run [f]ile" },
            { "<leader>tA", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "[t]est [A]ll files" },
            { "<leader>tS", function() require("neotest").run.run({ suite = true }) end, desc = "[t]est [S]uite" },
            { "<leader>tn", function() require("neotest").run.run() end, desc = "[t]est [n]earest" },
            { "<leader>tl", function() require("neotest").run.run_last() end, desc = "[t]est [l]ast" },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "[t]est [s]ummary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "[t]est [o]utput" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "[t]est [O]utput panel" },
            { "<leader>tt", function() require("neotest").run.stop() end, desc = "[t]est [t]erminate" },
            { "<leader>td", function() require("neotest").run.run({ suite = false, strategy = "dap" }) end, desc = "Debug nearest test" },
            { "<leader>tD", function() require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" }) end, desc = "Debug current file" },
        },
        config = function()
            local neotest_golang_opts = {
                go_test_args = { "-v", "-count=1", "-tags=unit,integration" },
                go_list_args = { "-tags=unit,integration" },
                dap_go_opts = {
                    delve = {
                        build_flags = { "-tags=unit,integration" },
                    },
                },
            }  -- Specify custom configuration
            require("neotest").setup({
                adapters = {
                    require("neotest-golang")(neotest_golang_opts), -- Registration
                },
                output = {
                    open_on_run = "short", -- Open the output window when tests run
                    enter = true,         -- Enter the output window when it opens
                    win_options = {       -- Window options for the output window
                        wrap = true,      -- Word wrap
                        number = false,   -- No line numbers needed in output
                    },
                },
                icons = {
                    child_indent = "│",
                    child_prefix = "├",
                    collapsed = "─",
                    expanded = "╮",
                    failed = "✘",      -- Clear X for failed
                    final_child_indent = " ",
                    final_child_prefix = "╰",
                    non_collapsible = "─",
                    passed = "✓",      -- Clear checkmark for passed
                    running = "●",     -- Solid circle for running (more visible than spinning)
                    running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- Braille spinner
                    skipped = "○",     -- Empty circle for skipped
                    unknown = "?"
                },
                -- Add these highlight groups for Rose Pine colors
                highlights = {
                    passed = "NeotestPassed",
                    failed = "NeotestFailed",
                    running = "NeotestRunning",
                    skipped = "NeotestSkipped",
                }
            })
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                    -- Rose Pine themed test status colors
                    vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#9ccfd8" })   -- foam (cyan/green)
                    vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#eb6f92" })   -- love (red)
                    vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#f6c177" })  -- gold (yellow)
                    vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = "#6e6a86" })  -- muted (grey)
                end,
            })

            vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#9ccfd8" })
            vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#eb6f92" })
            vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#f6c177" })
            vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = "#6e6a86" })
        end,
    },
}
