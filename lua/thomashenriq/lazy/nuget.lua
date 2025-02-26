return {
  'Speiser/nuget.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('nuget').setup()
  end,
}
