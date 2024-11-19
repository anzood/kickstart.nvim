return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VimEnter',
  init = function()
    -- Function to find and close [No Name] buffer
    local function close_no_name_buffer()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        -- Check if buffer is listed and has no name
        if vim.fn.buflisted(buf) == 1 and vim.api.nvim_buf_get_name(buf) == '' then
          vim.cmd('bd ' .. buf)
          break
        end
      end
    end

    -- Function to focus neo-tree and clean up
    local function focus_neo_tree_and_cleanup()
      vim.cmd 'Neotree focus'
      -- Use vim.schedule to ensure neo-tree gets focus before we close the buffer
      vim.schedule(close_no_name_buffer)
    end

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
        -- If it's the last buffer, recreate the initial state
        vim.cmd 'enew' -- Create new buffer
        vim.cmd('bd ' .. current_buf) -- Close the original buffer
        -- Focus neo-tree and clean up
        vim.schedule(focus_neo_tree_and_cleanup)
      end
    end, {})

    -- Set up autocmd to handle [No Name] buffer when opening files
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        -- If entering a named buffer (actual file)
        if bufname ~= '' then
          vim.schedule(close_no_name_buffer)
        end
      end,
    })
  end,
  opts = {
    options = {
      mode = 'buffers',
      separator_style = 'slant',
      always_show_bufferline = false,
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
      -- Background colors
      background = {
        bg = '#3c3836',
      },
      fill = {
        bg = '#3c3836',
      },

      -- Regular buffer
      buffer = {
        bg = '#3c3836',
        fg = '#928374',
      },
      buffer_visible = {
        bg = '#3c3836',
        fg = '#928374',
      },
      buffer_selected = {
        bg = '#504945',
        fg = '#ebdbb2',
        bold = true,
        italic = false,
      },

      -- Modified indicator
      modified = {
        bg = '#3c3836', -- Match unselected tab bg
        fg = '#fabd2f',
      },
      modified_visible = {
        bg = '#3c3836', -- Match unselected tab bg
        fg = '#fabd2f',
      },
      modified_selected = {
        bg = '#504945', -- Match selected tab bg
        fg = '#fabd2f',
      },

      -- Separator
      separator = {
        bg = '#3c3836',
        fg = '#3c3836',
      },
      separator_visible = {
        bg = '#3c3836',
        fg = '#3c3836',
      },
      separator_selected = {
        bg = '#504945',
        fg = '#3c3836',
      },

      -- Indicators
      indicator_visible = {
        bg = '#3c3836', -- Match unselected tab bg
        fg = '#fabd2f',
      },
      indicator_selected = {
        bg = '#504945', -- Match selected tab bg
        fg = '#fabd2f',
      },

      -- Diagnostics
      error = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      error_visible = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      error_selected = {
        bg = '#504945', -- Match selected tab bg
      },
      error_diagnostic = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      error_diagnostic_visible = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      error_diagnostic_selected = {
        bg = '#504945', -- Match selected tab bg
      },

      warning = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      warning_visible = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      warning_selected = {
        bg = '#504945', -- Match selected tab bg
      },
      warning_diagnostic = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      warning_diagnostic_visible = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      warning_diagnostic_selected = {
        bg = '#504945', -- Match selected tab bg
      },

      info = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      info_visible = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      info_selected = {
        bg = '#504945', -- Match selected tab bg
      },
      info_diagnostic = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      info_diagnostic_visible = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      info_diagnostic_selected = {
        bg = '#504945', -- Match selected tab bg
      },

      hint = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      hint_visible = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      hint_selected = {
        bg = '#504945', -- Match selected tab bg
      },
      hint_diagnostic = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      hint_diagnostic_visible = {
        bg = '#3c3836', -- Match unselected tab bg
      },
      hint_diagnostic_selected = {
        bg = '#504945', -- Match selected tab bg
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
    -- Close current buffer
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
