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

-- Inline completion ranges are computed when requested, so text deleted before accepting can leave them past the line end.
-- Clamp the range to the current buffer, and drop the item when its start no longer exists.
local function clamp_inline_completion(item)
  local range = item.range
  if not range then
    return item
  end

  local buf = range.buf
  local start_row, start_col, end_row, end_col = range:to_extmark()
  local last_row = vim.api.nvim_buf_line_count(buf) - 1
  local start_line = vim.api.nvim_buf_get_lines(buf, start_row, start_row + 1, false)[1]
  if not start_line or start_col > #start_line then
    return nil
  end

  end_row = math.min(end_row, last_row)
  local end_line = vim.api.nvim_buf_get_lines(buf, end_row, end_row + 1, false)[1]
  end_col = math.min(end_col, #end_line)
  item.range = vim.range.extmark(buf, start_row, start_col, end_row, end_col)
  return item
end

local function enable_completion(group)
  -- Omit "popup" so moving through candidates does not send completionItem/resolve on every selection change.
  vim.opt.completeopt = { "menuone", "noselect", "fuzzy" }

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if not client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, args.buf) then
        return
      end

      -- autotrigger covers server trigger characters and refreshes incomplete results while the menu is open.
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

      -- Also open the menu on identifier characters, as blink.cmp did; one autocmd per buffer serves every client.
      if #vim.api.nvim_get_autocmds({ group = group, event = "InsertCharPre", buffer = args.buf }) > 0 then
        return
      end
      vim.api.nvim_create_autocmd("InsertCharPre", {
        group = group,
        buffer = args.buf,
        callback = function()
          if vim.fn.pumvisible() == 0 and vim.v.char:match("[%w_]") then
            -- Request after the typed character is inserted; a newer request cancels a pending one.
            vim.schedule(vim.lsp.completion.get)
          end
        end,
      })
    end,
  })

  -- Not an expr mapping: accepting inline completion edits the buffer, which textlock forbids during expr evaluation.
  vim.keymap.set("i", "<Tab>", function()
    if vim.lsp.inline_completion.get({ on_accept = clamp_inline_completion }) then
      return
    end
    if vim.snippet.active({ direction = 1 }) then
      vim.snippet.jump(1)
      return
    end
    vim.api.nvim_feedkeys(vim.keycode("<Tab>"), "n", false)
  end, { desc = "Accept Inline Completion or Next Snippet Field" })

  -- Accept only an explicitly selected candidate; otherwise Enter inserts a newline.
  vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected ~= -1 then
      return "<C-y>"
    end
    return "<CR>"
  end, { expr = true, desc = "Accept Completion" })

  vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, { desc = "Show Completion" })
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
end

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
  -- Log only errors so chatty servers do not keep appending warnings to lsp.log.
  vim.lsp.log.set_level(vim.log.levels.ERROR)

  local group = vim.api.nvim_create_augroup("user.lsp", { clear = true })
  enable_completion(group)
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
