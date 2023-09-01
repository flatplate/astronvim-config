local function getTelescopeOpts(state, path)
  return {
    cwd = path,
    search_dirs = { path },
    -- attach_mappings = function (prompt_bufnr, map)
    --   local actions = require "telescope.actions"
    --   actions.select_default:replace(function()
    --     actions.close(prompt_bufnr)
    --     local action_state = require "telescope.actions.state"
    --     local selection = action_state.get_selected_entry()
    --     local filename = selection.filename
    --     if (filename == nil) then
    --       filename = selection[1]
    --     end
    --     -- any way to open the file without triggering auto-close event of neo-tree?
    --     -- require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
    --   end)
    --   return true
    -- end
  }
end

local DEBOUNCE_DELAY = 300
local timer = vim.loop.new_timer()

function debouncedCopilotSuggest()
  timer:stop()
  timer:start(
  DEBOUNCE_DELAY,
  0,
  vim.schedule_wrap(function()
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<Plug>(copilot-suggest)', true, true, true),
      'm',
      true
    )
  end)
  )
end

local function osDependentConfig(config)
  local isWindows = vim.loop.os_uname().sysname == "Windows_NT"
  if isWindows then
    return config['windows']
  end
  return config['default']
end

local config = {
  icons = {
    VimIcon = "",
    ScrollText = "",
    GitBranch = "",
    GitAdd = "",
    GitChange = "",
    GitDelete = "",
  },
  heirline = {
    -- define the separators between each section
    separators = {
      left = { "", " " }, -- separator for the left side of the statusline
      right = { " ", "" }, -- separator for the right side of the statusline
    },
    -- add new colors that can be used by heirline
    colors = function(hl)
      -- use helper function to get highlight group properties
      local comment_fg = astronvim.get_hlgroup("Comment").fg
      hl.git_branch_fg = comment_fg
      hl.git_added = comment_fg
      hl.git_changed = comment_fg
      hl.git_removed = comment_fg
      hl.blank_bg = astronvim.get_hlgroup("Folded").fg
      hl.file_info_bg = astronvim.get_hlgroup("Visual").bg
      hl.nav_icon_bg = astronvim.get_hlgroup("String").fg
      hl.nav_fg = hl.nav_icon_bg
      hl.folder_icon_bg = astronvim.get_hlgroup("Error").fg
      return hl
    end,
    attributes = {
      mode = { bold = true },
    },
    icon_highlights = {
      file_icon = {
        statusline = false,
      },
    },
  },
  header = {
    ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
    ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
    ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
    ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
    ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
    ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
  },
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "nightly", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "main", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },
  neoformat_try_node_exe = 1,

  -- Set colorscheme
  colorscheme = "gruvbox",

  -- Override highlight groups in any theme
  highlights = {
    duskfox = { -- a table of overrides
      Normal = { bg = "#000000" },
    },
    default_theme = function(highlights) -- or a function that returns one
      local C = require "default_theme.colors"

      highlights.Normal = { fg = C.fg, bg = C.bg }
      return highlights
    end,
  },

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
      number = true,
      relativenumber = true, -- sets vim.opt.relativenumber
      ignorecase = true,
      guifont = osDependentConfig({ windows = "JetBrains Mono NL:h10", default = "JetBrainsMono Nerd Font Mono:h10" }),
      foldmethod = "indent",
      foldenable = false,
      colorcolumn = "120",
      ut = 4000,
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      tabstop = 4,
      shiftwidth = 4,
      expandtab = true,
      bookmark_auto_save = 0,
    },
  },

  -- Default theme configuration
  default_theme = {
    diagnostics_style = { italic = true },
    -- Modify the color table
    colors = {
      fg = "#abb2bf",
    },
    plugins = { -- enable or disable extra plugin highlighting
      -- aerial = true,
      beacon = false,
      -- bufferline = false,
      dashboard = true,
      highlighturl = true,
      hop = false,
      indent_blankline = true,
      lightspeed = false,
      ["neo-tree"] = true,
      notify = true,
      ["nvim-tree"] = false,
      ["nvim-web-devicons"] = true,
      rainbow = true,
      symbols_outline = false,
      telescope = true,
      vimwiki = false,
      ["which-key"] = true,
    },
  },

  -- Disable AstroNvim ui features
  ui = {
    nui_input = true,
    -- telescope_select = true,
  },

  -- Configure plugins
  -- PLUGINS
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    -- p
    toggleterm = {
      direction = "vertical",
      size = 80
    },

    init = {
      -- You can disable default plugins as follows:
      ["goolord/alpha-nvim"] = { commit = "21a0f25"},
     {"ellisonleao/gruvbox.nvim"},
      -- You can also add new plugins here as well:
     { "rebelot/heirline.nvim", commit = "556666a" },
     { "prochri/telescope-all-recent.nvim", requires={"kkharji/sqlite.lua"}},
     { "ggandor/leap.nvim", config = function() 
        require('leap').add_default_mappings()
     end },
     { "MattesGroeger/vim-bookmarks" },
     { "tom-anders/telescope-vim-bookmarks.nvim", config = function()
       require('telescope').load_extension('vim_bookmarks')
     end },
     { "github/copilot.vim" },
     {
       "ThePrimeagen/harpoon",
       config = function()
         require("harpoon").setup({
           menu = {
             width = vim.api.nvim_win_get_width(0) - 4,
           }
         })
       end
     },
     { 'alvan/vim-closetag' },
     { 'tpope/vim-fugitive' },
     { 'FooSoft/vim-argwrap' },
     { 'sam4llis/nvim-tundra',
       config = function()
         require('nvim-tundra').setup({
           transparent_background = false,
           editor = {
             search = {},
             substitute = {},
           },
           syntax = {
             booleans = { bold = true, italic = true },
             comments = { bold = true, italic = true },
             conditionals = {},
             constants = { bold = true },
             functions = {},
             keywords = {},
             loops = {},
             numbers = { bold = true },
             operators = { bold = true },
             punctuation = {},
             strings = {},
             types = { italic = true },
           },
           iagnostics = {
             errors = {},
             warnings = {},
             information = {},
             hints = {},
           },
           plugins = {
             lsp = true,
             treesitter = true,
             context = true,
             gitsigns = true,
             telescope = true,
           },
         })
       end

     },
     { 'mattn/emmet-vim' },
     { 'ludovicchabant/vim-gutentags' },
     {
       "kylechui/nvim-surround",
       tag = "*", -- Use for stability; omit to use `main` branch for the latest features
       config = function()
         require("nvim-surround").setup({
           -- Configuration here, or leave empty to use defaults
         })
       end
     },
     { 'fatih/vim-go' },
      { 'sbdchd/neoformat' },
      { 'petertriho/nvim-scrollbar'  },
      {
        "ray-x/lsp_signature.nvim",
        event = "BufRead",
        config = function()
          require("lsp_signature").setup()
        end,
      },
    },
    -- All other entries override the setup() call for default plugins
    --
    ["null-ls"] = function(config)
      local null_ls = require "null-ls"
      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      config.sources = {
        -- Set a formatter
        null_ls.builtins.formatting.prettierd.with({
          filetypes = {
            "css", "scss", "html", "json", "yaml", "markdown", "graphql", "md", "txt", "python",
          }
        }),
        null_ls.builtins.formatting.rufo,
        -- Set a linter
        null_ls.builtins.diagnostics.rubocop,
      }
      -- set up null-ls's on_attach function
      config.on_attach = function(client)
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*",
          callback = function()
            if vim.bo.filetype == "typescript" or vim.bo.filetype == "javascript" or
                vim.bo.filetype == "javascriptreact" or
                vim.bo.filetype == "typescriptreact"
            then
              -- NOTE: don't format javascript files
              vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})
              -- vim.cmd("EslintFixAll")
              vim.lsp.buf.format({ name = "eslint" }) -- works too
              return
            elseif vim.bo.filetype == "proto" then
              local view_state = vim.fn.winsaveview()
              vim.cmd("%!clang-format --assume-filename=%")
              vim.fn.winrestview(view_state)
            end
          end,
        }
        )
        -- NOTE: You can remove this on attach function to disable format on save
        if client.resolved_capabilities.document_formatting then
          vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
            command = 'EslintFixAll',
            group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
          })
        end
      end
      return config -- return final config table
    end,
    ["neo-tree"] = function(config)
      -- TODO Add keybinding for jump to last open buffer location in tree, and disable auto jumping
      -- Search in children of directory under cursor
      config.filesystem.window = {
        mappings = {
          ["<c-k>f"] = "telescope_find",
          ["<c-k>g"] = "telescope_grep"
        }
      }
      config.filesystem.commands = {
        telescope_find = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').find_files(getTelescopeOpts(state, path))
        end,
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
        end
      }
      config.filesystem.filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      }
      return config
    end,
    treesitter = {
      ensure_installed = { "lua", "tsx", "typescript" },
    },
    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "data" .. "/packer_compiled.lua",
    },
  },

  -- LuaSnip Options
  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {},
    -- Extend filetypes
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  -- Modify which-key registration
  ["which-key"] = {
    -- Add bindings
    register_mappings = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- which-key registration table for normal mode, leader prefix
          -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
        },
      },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },


  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without lsp-installer
    servers = {
      -- "pyright"
    },
    -- easily add or disable built in mappings added during LSP attaching
    mappings = {
      n = {
        -- ["<leader>lf"] = false -- disable formatting keymap
      },
    },
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server].setup(opts)
    -- end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      tsserver = {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end
      },
      -- example for addings schemas to yamlls
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  -- MAPPINGS
  mappings = {
    -- first key is the mode
    n = {
      -- second key is the lefthand side of the map
      ["<C-s>"] = { ":wa<cr>", desc = "Save File" },
      [osDependentConfig({ windows = "<C-\\>", default = "<C-'>" })] = { ":ToggleTerm<CR>", desc = "Open toggle term" },
      ["<C-p>"] = { "\"qp", desc = "Paste from register q" },
      ["<C-y>"] = { "\"qy", desc = "Copy to register q" },
      ['<c-cr>'] = { function() vim.lsp.buf.code_action() end },
      ['<c-s-tab>'] = { function() require('telescope.builtin').buffers({ sort_lastused = true,
          ignore_current_buffer = true })
      end },
      ['<c-tab>'] = { ":b#<cr>" },
      ['<c-`>'] = { function() require('telescope.builtin').marks({ sort_lastused = true }) end },
      ['<leader>a'] = { ":ArgWrap<cr>" },
      ['<leader>df'] = { ":GoPrintlnFileLine<CR>" }, -- TODO Make this only work in go files
      ['<leader>nd'] = { function() vim.notifiy.dismiss() end, desc = "Dismiss notifications" },
      ['<c-s-n>'] = { ":cp<cr>" },
      ['<c-n>'] = { ":cn<cr>" },
      ['<leader>ff'] = { ":Telescope find_files hidden=true<CR>" },
      ['<leader>fb'] = { ":Telescope vim_bookmarks all<CR>" },
      ['<leader>fp'] = { function() require('telescope.builtin').live_grep({ grep_open_files = true }) end,
        desc = "Search in open files" },
      ['<leader>fg'] = { ":Telescope git_status<CR>",  desc = "Telescope git diff files" },
      ['<leader>fi'] = { function()
        vim.cmd('noau normal! "zyiw"')
        require('telescope.builtin').find_files({ search_file = vim.fn.getreg("z") })
      end },
      ['<leader>fr'] = { ":Telescope resume<CR>" },
      ['<leader>gl'] = { ":Git blame<CR>" },
      ['gv'] = { ":vsplit<CR>gd" },
      ['<leader>sr'] = { 'yiw:%s/<C-R>*' },
      ['<leader>ss'] = { 'yiw:s/<C-R>*/' },
      -- ['<leader>ci'] = { "<Plug>(copilot-suggest)" },
      ['<leader>bb'] = { function() require("harpoon.mark").add_file() end },
      ['<c-1>'] = { function() require("harpoon.ui").toggle_quick_menu() end }
      -- TODO Some keybinding for search and replace word under cursor:
      -- ['<c-g>'] = {"<space>gg"}, I tried to use c-g for opening the lazy git window because escaping inside the window is tricky
      -- TODO Telescope grep in files in the quickfix list
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
       ["<esc>"] = { "<C-\\><C-n>", desc = "To normal mode in terminal" },
       [osDependentConfig({ windows = "<C-\\>", default = "<C-'>" })] = { "<C-\\><C-n>:ToggleTerm<CR>",
        desc = "Close toggle term" },
       -- ,
    },
    i = {
      ["<C-p>"] = { "<esc>:Telescope oldfiles<CR>", desc = "Save File" },
      ['<c-s-tab>'] = { function() require('telescope.builtin').buffers({ sort_lastused = true,
          ignore_current_buffer = true })
      end },
      ['<c-tab>'] = { "<esc>:b#<cr>a" },
      ['<c-l>'] = {'copilot#Accept("<CR>")', expr = true, silent = true, noremap = true, replace_keycodes = false },
    },

    -- Remaps for the refactoring operations currently offered by the refactoring.nvim plugin
    v = {
      ["<leader>re"] = { function() require('refactoring').refactor('Extract Function') end },
      ["<leader>rf"] = { function() require('refactoring').refactor('Extract Function To File') end },
      ["<leader>rv"] = { function() require('refactoring').refactor('Extract Variable') end },
      ["<leader>ri"] = { function() require('refactoring').refactor('Inline Variable') end },
      ["<leader>fc"] = { function()
        vim.cmd('noau visual! "zy"')
        require('telescope.builtin').grep_string({ search = vim.fn.getreg("z") })
      end },
      ['<c-cr>'] = { function() vim.lsp.buf.range_code_action() end },
    }
  },

  -- This function is run last
  -- good place to configuring augroups/autocommands and custom filetypes
  polish = function()
    -- Set key binding
    -- Set autocommands

    vim.api.nvim_create_augroup("packer_conf", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })
    vim.api.nvim_create_autocmd("TextChangedI", {
      callback = function() 
        debouncedCopilotSuggest() 
      end
    })
    vim.api.nvim_create_user_command('CopyLines', function(opts)
      vim.cmd('noau visual! qaq')
      vim.cmd('g/' .. opts.args .. '/y A')
      vim.cmd('let @+ = @a')
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('CopyFileAndLine', function(opts)
      vim.cmd('let @*=join([expand("%"),  line(".")], ":")')
    end, { nargs = 0 })

    vim.api.nvim_create_user_command('CloseAllBuffers', function(opts)
      vim.cmd('%bd|e#')
    end, { nargs = 0 })

    vim.api.nvim_create_user_command('GoPrintlnFileLine', function(opts)
      local path = vim.fn.getreg("%")
      local file = path:match("([^/]+)$")

      local line_num = vim.api.nvim_win_get_cursor(0)[1]

      vim.cmd("let @z=\"" .. file .. ":" .. line_num .. "\"")
      vim.cmd("execute \"normal ofmt.Println(\\\"\"")
      vim.cmd("execute \"normal\\\"zp\"")
      vim.cmd("execute \"i\\\")\"")

    end, { nargs = 0 })

    vim.api.nvim_create_user_command("CopySearch", function(opts)
      local hits = {}

      -- This function gets executed for each occurrence of the search pattern
      local function replacer()
        table.insert(hits, vim.fn.submatch(0))
        return vim.fn.submatch(0)
      end

      -- Use the substitution command with the replacer function
      vim.api.nvim_exec(string.format('%%s///\\=v:lua.copy_matches_neovim.replacer()//gne'), false)

      -- If no register is provided, use the clipboard register "+"
      reg = opts.reg or '+'

      -- Set the contents of the chosen register to the hits
      vim.fn.setreg(reg, table.concat(hits, '\n') .. '\n', 'l')
    end, { range = true, register = true })

    -- TODO Create an autocommand for autosave
    -- context:  https://vi.stackexchange.com/questions/74/is-it-possible-to-make-vim-auto-save-files
    -- autocmd CursorHold,CursorHoldI * update
    vim.api.nvim_set_keymap('i', '<C-/>', 'copilot#Accept("<CR>")', {expr=true, silent=true})
  end,
}

return config
