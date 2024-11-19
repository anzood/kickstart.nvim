-- NOTE: Requires lazygit to be installed locally
-- See: https://github.com/jesseduffield/lazygit#installation

return {
  { -- Add lazygit integration
    'kdheepak/lazygit.nvim',
    -- optional: setup lazy loading
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional: dependencies
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- Add a keymap to open lazygit
    keys = {
      { '<leader>gg', '<cmd>LazyGit<CR>', desc = 'Open LazyGit' },
    },
  },
} 