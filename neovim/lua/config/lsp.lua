-- Server definitions live in lsp/*.lua and personal overrides in after/lsp/*.lua.
local M = {}

local servers = {
  "clangd",
  "rust_analyzer",
  "gopls",
  "lua_ls",
  "terraformls",
  "phpantom_lsp",
  "basedpyright",
  "copilot",
}

local function enable_inline_completion(group)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if not client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, args.buf) then
        return
      end

      vim.lsp.inline_completion.enable(true, { bufnr = args.buf })
      vim.keymap.set("i", "<M-]>", function()
        vim.lsp.inline_completion.select({ bufnr = args.buf, count = 1 })
      end, { buffer = args.buf, desc = "Next Inline Completion" })
      vim.keymap.set("i", "<M-[>", function()
        vim.lsp.inline_completion.select({ bufnr = args.buf, count = -1 })
      end, { buffer = args.buf, desc = "Previous Inline Completion" })
    end,
  })
end

local function format_on_save(group)
  -- Format Rust files with rustfmt before saving.
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
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
    group = group,
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
end

local function start()
  -- Load blink.cmp first so its plugin file registers completion capabilities for every server.
  require("lazy").load({ plugins = { "blink.cmp" } })

  -- Log only errors so chatty servers do not keep appending warnings to lsp.log.
  vim.lsp.log.set_level(vim.log.levels.ERROR)

  local group = vim.api.nvim_create_augroup("user.lsp", { clear = true })
  enable_inline_completion(group)
  format_on_save(group)

  -- Enable only servers whose executables are available.
  for _, server in ipairs(servers) do
    local config = vim.lsp.config[server]
    local command = config and config.cmd

    if
      type(command) == "table"
      and type(command[1]) == "string"
      and vim.fn.executable(command[1]) == 1
    then
      vim.lsp.enable(server)
    end
  end

  -- Configure diagnostic display.
  vim.diagnostic.config({
    virtual_text = {
      current_line = true,
    },
    signs = {
      text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
      },
    },
    underline = true,
    severity_sort = true,
    update_in_insert = false,
    float = {
      border = "rounded",
      source = "if_many",
    },
  })
end

function M.setup()
  -- Defer LSP and completion setup until a file buffer is opened; this runs before that buffer's FileType.
  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("user.lsp.start", { clear = true }),
    once = true,
    callback = start,
  })
end

return M
