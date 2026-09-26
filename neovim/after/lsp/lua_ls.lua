return {
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
    -- Include snacks.nvim so the Snacks global resolves without lazydev.nvim.
    local snacks_library = vim.api.nvim_get_runtime_file("lua/snacks", false)[1]
    if snacks_library then
      table.insert(library, snacks_library)
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
}
