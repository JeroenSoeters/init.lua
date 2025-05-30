return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        { "mfussenegger/nvim-dap",
            config = function()
                local dap = require("dap")

                -- Define breakpoint signs with better icons
                vim.fn.sign_define('DapBreakpoint', {
                    text = '●', -- solid circle
                    texthl = 'DapBreakpoint',
                    linehl = '',
                    numhl = ''
                })

                vim.fn.sign_define('DapBreakpointCondition', {
                    text = '◆', -- diamond for conditional
                    texthl = 'DapBreakpointCondition',
                    linehl = '',
                    numhl = ''
                })

                vim.fn.sign_define('DapLogPoint', {
                    text = '◉', -- circle with dot for log points
                    texthl = 'DapLogPoint',
                    linehl = '',
                    numhl = ''
                })

                vim.fn.sign_define('DapStopped', {
                    text = '▶', -- arrow pointing right for current execution
                    texthl = 'DapStopped',
                    linehl = 'DapStoppedLine',
                    numhl = ''
                })

                vim.fn.sign_define('DapBreakpointRejected', {
                    text = '✖', -- X for rejected breakpoints
                    texthl = 'DapBreakpointRejected',
                    linehl = '',
                    numhl = ''
                })

                -- Load keymaps
                vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Debug: Continue" })
                vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Debug: Step Over" })
                vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Debug: Step Into" })
                vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Debug: Step Out" })
                vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
                vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "Debug: Set Conditional Breakpoint" })
                vim.keymap.set("n", "<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "Debug: Set Log Point" })
                vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Debug: Open REPL" })
            end
        },
        "nvim-neotest/nvim-nio"
    },
    config = function()
        local dapui = require("dapui")
        dapui.setup({
            -- Better icons for dap-ui
            icons = {
                expanded = "▾",
                collapsed = "▸",
                current_frame = "▸"
            },
            mappings = {
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                edit = "e",
                repl = "r",
                toggle = "t",
            },
            controls = {
                enabled = true,
                element = "repl",
                -- Using default icons - they're more consistent
            },
            layouts = {
                {
                    elements = {
                        { id = "watches", size = 0.33 },
                        { id = "stacks", size = 0.33 },
                        { id = "breakpoints", size = 0.34 }
                    },
                    size = 0.25,
                    position = "left"
                },
                {
                    elements = {
                        { id = "scopes", size = 1.0 }
                    },
                    size = 0.25,
                    position = "bottom"
                },
                {
                    elements = {
                        { id = "repl", size = 0.5 },
                        { id = "console", size = 0.5 }
                    },
                    size = 0.25,
                    position = "bottom"
                }
            },
            floating = {
                max_height = nil,
                max_width = nil,
                border = "single",
                mappings = {
                    close = { "q", "<Esc>" }
                }
            },
            render = {
                max_type_length = nil,
                max_value_lines = 100
            }
        })

        -- Set up breakpoint highlight colors
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("DapUIHighlights", { clear = true }),
            pattern = "*",
            callback = function()
                -- Breakpoint colors using Rose Pine colors
                vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#eb6f92" }) -- rose pine love (red)
                vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f6c177" }) -- rose pine gold
                vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#c4a7e7" }) -- rose pine iris (purple)
                vim.api.nvim_set_hl(0, "DapStopped", { fg = "#9ccfd8" }) -- rose pine foam (cyan)
                vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2a273f" }) -- subtle background
                vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#6e6a86" }) -- rose pine muted
            end,
        })

        -- Apply colors immediately
        vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#eb6f92" })
        vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f6c177" })
        vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#c4a7e7" })
        vim.api.nvim_set_hl(0, "DapStopped", { fg = "#9ccfd8" })
        vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2a273f" })
        vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#6e6a86" })

        -- Add keymaps for dapui
        vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Debug: Toggle UI" })
        vim.keymap.set("n", "<leader>de", function() dapui.eval() end, { desc = "Debug: Evaluate Expression" })

        -- Setup listeners
        local dap = require("dap")
        dap.listeners.after = dap.listeners.after or {}
        dap.listeners.before = dap.listeners.before or {}

        -- Track nvim-tree state and original buffer
        local nvim_tree_was_open = false
        local original_bufnr = nil

        dap.listeners.before.attach.dapui_config = function()
            -- Store current buffer
            original_bufnr = vim.api.nvim_get_current_buf()
            -- Check if nvim-tree is open and close it
            local nvim_tree_api = require("nvim-tree.api")
            local tree_winid = nvim_tree_api.tree.winid()
            if tree_winid and vim.api.nvim_win_is_valid(tree_winid) then
                nvim_tree_was_open = true
                nvim_tree_api.tree.close()
            end
            dapui.open()
        end

        dap.listeners.before.launch.dapui_config = function()
            -- Store current buffer
            original_bufnr = vim.api.nvim_get_current_buf()
            -- Check if nvim-tree is open and close it
            local nvim_tree_api = require("nvim-tree.api")
            local tree_winid = nvim_tree_api.tree.winid()
            if tree_winid and vim.api.nvim_win_is_valid(tree_winid) then
                nvim_tree_was_open = true
                nvim_tree_api.tree.close()
            end
            dapui.open()
        end

        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
            -- Reopen nvim-tree if it was open before
            if nvim_tree_was_open then
                local nvim_tree_api = require("nvim-tree.api")
                nvim_tree_api.tree.open()
                nvim_tree_was_open = false
                -- Return cursor to original buffer
                if original_bufnr and vim.api.nvim_buf_is_valid(original_bufnr) then
                    for _, win in pairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_buf(win) == original_bufnr then
                            vim.api.nvim_set_current_win(win)
                            break
                        end
                    end
                end
            end
        end

        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
            -- Reopen nvim-tree if it was open before
            if nvim_tree_was_open then
                local nvim_tree_api = require("nvim-tree.api")
                nvim_tree_api.tree.open()
                nvim_tree_was_open = false
                -- Return cursor to original buffer
                if original_bufnr and vim.api.nvim_buf_is_valid(original_bufnr) then
                    for _, win in pairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_buf(win) == original_bufnr then
                            vim.api.nvim_set_current_win(win)
                            break
                        end
                    end
                end
            end
        end

        -- Also handle manual dapui toggle
        local original_toggle = dapui.toggle
        dapui.toggle = function()
            local nvim_tree_api = require("nvim-tree.api")
            local tree_winid = nvim_tree_api.tree.winid()
            local current_winid = vim.api.nvim_get_current_win()
            local current_bufnr = vim.api.nvim_get_current_buf()

            -- Check if dapui is currently visible
            local dapui_visible = false
            for _, win in pairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local buf_name = vim.api.nvim_buf_get_name(buf)
                if string.match(buf_name, "dapui_") then
                    dapui_visible = true
                    break
                end
            end

            -- If dapui is about to open and nvim-tree is open
            if not dapui_visible then
                if tree_winid and vim.api.nvim_win_is_valid(tree_winid) then
                    nvim_tree_was_open = true
                    nvim_tree_api.tree.close()
                end
            else
                -- dapui is about to close, reopen nvim-tree if it was open
                if nvim_tree_was_open then
                    vim.defer_fn(function()
                        nvim_tree_api.tree.open()
                        nvim_tree_was_open = false
                        -- Return cursor to original buffer if it exists and is valid
                        if current_bufnr and vim.api.nvim_buf_is_valid(current_bufnr) then
                            for _, win in pairs(vim.api.nvim_list_wins()) do
                                if vim.api.nvim_win_get_buf(win) == current_bufnr then
                                    vim.api.nvim_set_current_win(win)
                                    break
                                end
                            end
                        end
                    end, 100) -- small delay to ensure dapui closes first
                end
            end

            original_toggle()
        end
    end
}
