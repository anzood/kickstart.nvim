-- In lua/kickstart/plugins/bufferline.lua
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VimEnter',
  init = function()
    -- Define the safe close function in the global namespace
    vim.api.nvim_create_user_command('SafeCloseBuffer', function()
      -- Get the current buffer number
      local current_buf = vim.api.nvim_get_current_buf()

      -- Get all listed buffers
      local buffers = vim.tbl_filter(function(buf)
        return vim.fn.buflisted(buf) == 1
      end, vim.api.nvim_list_bufs())

      -- If we have more than one buffer
      if #buffers > 1 then
        -- Switch to the previous buffer before closing
        vim.cmd 'BufferLineCyclePrev'
        -- Then close the original buffer
        vim.cmd('bd ' .. current_buf)
      else
        -- If it's the last buffer, create a new one before closing this one
        vim.cmd 'enew'
        vim.cmd('bd ' .. current_buf)
      end
    end, {})
  end,
  opts = {
    options = {
      mode = 'buffers',
      separator_style = 'slant',
      always_show_bufferline = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      color_icons = true,
      diagnostics = 'nvim_lsp',
      diagnostics_update_in_insert = false,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          text_align = 'left',
          separator = true,
        },
      },
      hover = {
        enabled = true,
        delay = 200,
        reveal = { 'close' },
      },
    },
    highlights = {
      background = {
        bg = '#3c3836',
      },
      buffer_selected = {
        bg = '#504945',
        bold = true,
        italic = false,
      },
      buffer_visible = {
        bg = '#3c3836',
      },
      close_button = {
        bg = '#3c3836',
        fg = '#928374',
      },
      close_button_selected = {
        fg = '#ebdbb2',
        bg = '#504945',
      },
      close_button_visible = {
        fg = '#928374',
      },
      fill = {
        bg = '#3c3836',
      },
      indicator_selected = {
        fg = '#fabd2f',
      },
      modified = {
        fg = '#fabd2f',
      },
      modified_selected = {
        fg = '#fabd2f',
      },
      modified_visible = {
        fg = '#fabd2f',
      },
      separator = {
        bg = '#3c3836',
        fg = '#3c3836',
      },
      separator_selected = {
        bg = '#504945',
        fg = '#3c3836',
      },
      separator_visible = {
        bg = '#3c3836',
        fg = '#3c3836',
      },
      tab = {
        bg = '#3c3836',
        fg = '#928374',
      },
      tab_selected = {
        bg = '#504945',
        fg = '#ebdbb2',
      },
    },
  },
  config = function(_, opts)
    vim.opt.termguicolors = true
    require('bufferline').setup(opts)
  end,
  keys = {
    -- Buffer navigation with Tab in normal mode
    { '<Tab>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer', mode = 'n' },
    { '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer', mode = 'n' },
    -- Alternative navigation with Shift-h/l
    { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Previous buffer' },
    { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
    -- Close current buffer (now using our safe close command)
    { '<leader>bc', '<cmd>SafeCloseBuffer<cr>', desc = 'Close current buffer' },
    -- Close all buffers except current
    { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Close other buffers' },
    -- Buffer picking
    { '<leader>bp', '<cmd>BufferLinePick<cr>', desc = 'Pick buffer' },
    -- Move buffer position
    { '<leader>bl', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer right' },
    { '<leader>bh', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer left' },
  },
}
