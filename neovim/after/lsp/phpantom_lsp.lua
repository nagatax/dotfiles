-- Neovim 0.12 drops workspace/diagnostic results for document-pulled buffers, leaving stale
-- diagnostics after workspace/diagnostic/refresh. Fall back to document pulls on refresh.
return {
  on_init = function(client)
    local provider = client.server_capabilities.diagnosticProvider
    if type(provider) == "table" then
      provider.workspaceDiagnostics = false
    end
  end,
}
