-- rustaceanvim relies on the native Neovim LSP client and configurations
-- It does NOT use a .setup() function. Instead, you define a global variable.

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
    -- rust-tools 'hover_actions' are now 'hover_actions' in rustaceanvim
    hover_actions = {
      auto_focus = false,
      replace_builtin_hover = true, 
    },
    -- Float options (borders)
    float_win_config = {
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },
      auto_focus = false,
    },
  },

  -- LSP configuration
  server = {
    -- equivalent to 'on_initialized'
    on_attach = function(client, bufnr)
      -- Native Inlay Hints (Neovim 0.10+)
      -- rust-tools used its own inlay hints, but now we use Neovim's native ones.
      if client.server_capabilities.inlayHintProvider then
         vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,

    -- standalone file support
    standalone = true,

    -- Settings passed to rust-analyzer
    default_settings = {
      ['rust-analyzer'] = {
        -- You can put specific rust-analyzer settings here
      },
    },
  },

  -- DAP configuration
  dap = {
    -- rustaceanvim attempts to find the adapter automatically,
    -- but you can override it here if you need your specific 'rt_lldb' setup.
    adapter = {
      type = "executable",
      command = "lldb-vscode",
      name = "rt_lldb",
    },
  },
}
