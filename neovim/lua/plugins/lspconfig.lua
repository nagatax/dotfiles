return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.lsp.config("terraformls", { filetypes = { "tf", "terraform", "terraform-vars" } })
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          gofumpt = true,
          staticcheck = true,
          templateExtensions = { "gotmpl" },
        },
      },
    })
    vim.lsp.config("lua_ls", {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath("config")
            and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
          then
            return
          end
        end

        local library = { vim.env.VIMRUNTIME }
        local lspconfig_library = vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1]
        if lspconfig_library then
          table.insert(library, lspconfig_library)
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            version = "LuaJIT",
            path = { "lua/?.lua", "lua/?/init.lua" },
          },
          workspace = {
            checkThirdParty = false,
            library = library,
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })

    local servers = {
      "clangd",
      "rust_analyzer",
      "gopls",
      "lua_ls",
      "terraformls",
      "intelephense",
      "basedpyright",
    }
    local enabled_servers = {}

    -- Enable only servers whose executables are available.
    for _, server in ipairs(servers) do
      local config = vim.lsp.config[server]
      local command = config and config.cmd

      if
        type(command) == "table"
        and type(command[1]) == "string"
        and vim.fn.executable(command[1]) == 1
      then
        if server == "rust_analyzer" then
          vim.lsp.config(server, {
            settings = {
              ["rust-analyzer"] = {
                check = {
                  command = "clippy",
                },
              },
            },
          })
        end

        vim.lsp.enable(server)
        table.insert(enabled_servers, server)
      end
    end

    -- Re-evaluate the initial buffer after startup because its FileType event may run before this plugin loads.
    if vim.v.vim_did_enter == 0 then
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          vim.schedule(function()
            vim.lsp.enable(enabled_servers)
          end)
        end,
      })
    end

    -- Configure diagnostic display.
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      severity_sort = true,
      update_in_insert = false,
      float = {
        border = "rounded",
        source = true,
      },
    })

    -- Format Rust files with rustfmt before saving.
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.rs",
      callback = function(args)
        local clients = vim.lsp.get_clients({
          bufnr = args.buf,
          name = "rust_analyzer",
          method = "textDocument/formatting",
        })

        if #clients == 0 then
          return
        end

        vim.lsp.buf.format({
          bufnr = args.buf,
          name = "rust_analyzer",
          async = false,
          timeout_ms = 3000,
        })
      end,
    })

    -- Organize imports and format Go files with gopls before saving.
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function(args)
        local clients = vim.lsp.get_clients({
          bufnr = args.buf,
          name = "gopls",
          method = "textDocument/formatting",
        })

        if #clients == 0 then
          return
        end

        local client = clients[1]
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        ---@cast params lsp.CodeActionParams
        params.context = {
          diagnostics = {},
          only = { "source.organizeImports" },
        }

        local response = client:request_sync(
          "textDocument/codeAction",
          params,
          3000,
          args.buf
        )

        for _, action in ipairs(response and response.result or {}) do
          if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
          end
        end

        vim.lsp.buf.format({
          bufnr = args.buf,
          name = "gopls",
          async = false,
          timeout_ms = 3000,
        })
      end,
    })
  end,
}
