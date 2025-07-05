return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",  -- Keep mason but NOT mason-lspconfig
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        -- Setup conform
        require("conform").setup({
            formatters_by_ft = {
                go = { "gofmt", "goimports" },
            }
        })

        -- Setup completion
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- Setup UI feedback
        require("fidget").setup({})

        -- Setup Mason (only for installing programs)
        require("mason").setup()

        -- Configure language servers
        local lspconfig = require("lspconfig")

        -- Setup common on_attach function
        local on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, noremap = true, silent = true }

            -- Define keymaps
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<F6>', vim.lsp.buf.rename, opts)
            vim.keymap.set({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({async = true}) end, opts)
            vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, opts)

            -- Enable inlay hints safely
            pcall(function()
                if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    if type(vim.lsp.inlay_hint) == "table" and vim.lsp.inlay_hint.enable then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    elseif type(vim.lsp.inlay_hint) == "function" then
                        vim.lsp.inlay_hint(bufnr, true)
                    end
                end
            end)
        end

        -- Set up servers manually (no mason-lspconfig)
        -- Set up gopls
        lspconfig.gopls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = {"gopls"},
            filetypes = {"go", "gomod", "gowork", "gotmpl"},
            root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = true,
                    buildFlags = {"-tags=unit,integration,e2e"},
                    usePlaceholders = true,
                    completeUnimported = true,
                }
            },
        }

        -- Set up lua_ls
        lspconfig.lua_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = {
                        globals = { "vim", "bit", "it", "describe", "before_each", "after_each" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }

        lspconfig.golangci_lint_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "golangci-lint-langserver" },
            filetypes = { "go", "gomod" },
            root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
            init_options = {
                command = { "golangci-lint", "run", "--output.json.path", "stdout", "--show-stats=false", "--issues-exit-code=1" },
            },
        }

        -- Set up rust_analyzer if installed
        if vim.fn.executable('rust-analyzer') == 1 then
            lspconfig.rust_analyzer.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }
        end

        -- A command to install LSP servers from Mason manually
        vim.api.nvim_create_user_command("InstallLSP", function()
            vim.cmd("MasonInstall lua-language-server rust-analyzer gopls  golangci-lint-langserver")
        end, {})

        -- Reserve a space in the gutter
        vim.opt.signcolumn = 'yes'

        -- Set up completion
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                    { name = 'buffer' },
                })
        })

        -- Configure diagnostics appearance
        vim.diagnostic.config({
            underline = true,
            update_in_insert = false,
            virtual_text = true,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
