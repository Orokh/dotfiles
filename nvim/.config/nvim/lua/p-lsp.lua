local lsp = require("lsp-zero")

lsp.preset("recommended")

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
})

local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    -- [R]e[n]ame
    vim.keymap.set("n", "<leader>rn", function()
        vim.lsp.buf.rename()
    end, opts)
    -- [C]ode [A]ction
    vim.keymap.set("n", "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, opts)

    -- [G]oto [D]efinition
    vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
    end, opts)
    -- [G]oto [R]eferences
    vim.keymap.set("n", "gr", function()
        vim.lsp.buf.references()
    end, opts)

    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("i", "<C-k>", function()
        vim.lsp.buf.signature_help()
    end, opts)

    -- [W]orkspace [S]ymbols
    vim.keymap.set("n", "<leader>ws", function()
        vim.lsp.buf.workspace_symbol()
    end, opts)
    -- [D]ocument [S]ymbols
    vim.keymap.set("n", "<leader>ds", function()
        vim.lsp.buf.document_symbol()
    end, opts)

    -- Diagnostics
    vim.keymap.set("n", "<leader>d", function()
        vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.goto_prev()
    end, opts)

    -- format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format()
        end,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*" },
        command = [[%s/\s\+$//e]],
    })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_config = {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
        on_attach(_, bufnr)
    end,
}

require("mason-lspconfig").setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup(lsp_config)
    end,
})

require("lspconfig").tsserver.setup({
  capabilities = capabilities,
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
  end,
})

lsp.setup()

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.sqlfluff,
        null_ls.builtins.diagnostics.shellcheck.with({ filetypes = { "sh", "zsh" } }),
        null_ls.builtins.formatting.shfmt.with({ filetypes = { "sh", "zsh" }, args = { "-filename", "$FILENAME", "-i", "4" } }),
        null_ls.builtins.formatting.prettier.with({
            filetypes = {
                "javascript",
                "typescript",
                "json",
                "yaml",
                "markdown",
                "graphql",
                "md",
                "txt",
            },
            only_local = "node_modules/.bin",
        }),
    },
})

require("mason-null-ls").setup({
    ensure_installed = nil,
    automatic_installation = true,
})
