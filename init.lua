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
local counter = 0


local function VisualSelectError()
  local diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
  if #diagnostics == 0 then
    vim.api.nvim_out_write("No errors on this line\n")
    return
  end

  local start_pos = diagnostics[1].range["start"]
  local end_pos = diagnostics[1].range["end"]

  vim.fn.cursor(end_pos.line + 1, end_pos.character + 1)
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

local function neovideScale(amount)
	local temp = vim.g.neovide_scale_factor + amount
	if temp < 0.5 then
		return
	end
	vim.g.neovide_scale_factor = temp
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
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)userinit
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
      makeprg = "yarn tsc \\| sed 's/(\\(.*\\),\\(.*\\)):/:\\1:\\2:/' \\| sed 's/@cresta/packages/' \\| sed 's/:\\ /\\//g'"
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
  -- TODO Add https://github.com/chrisgrieser/nvim-early-retirement
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    -- p
    --
    -- You can disable default plugins as follows:
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      opts = {
        show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
        debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
        disable_extra_info = 'no', -- Disable extra information (e.g: system prompt) in the response.
        -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
      },
      build = function()
        vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
      end,
      event = "VeryLazy",
      
      "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
      debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
      disable_extra_info = 'no', -- Disable extra information (e.g: system prompt) in the response.
      -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
    },
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    lazy=false,
    keys = {
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      {
        "<leader>ccv",
        ":CopilotChatVisual",
        mode = "x",
        desc = "CopilotChat - Open in vertical split",
      },
      {
        "<leader>ccx",
        ":CopilotChatInPlace<cr>",
        mode = "x",
        desc = "CopilotChat - Run in-place code",
      },
    },keys = {
        { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
        { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
        {
          "<leader>ccv",
          ":CopilotChatVisual",
          mode = "x",
          desc = "CopilotChat - Open in vertical split",
        },
        {
          "<leader>ccx",
          ":CopilotChatInPlace<cr>",
          mode = "x",
          desc = "CopilotChat - Run in-place code",
        },
      },
    }, 
      {
        "rest-nvim/rest.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
          require("rest-nvim").setup({
            -- Open request results in a horizontal split
            result_split_horizontal = false,
            -- Keep the http file buffer above|left when split horizontal|vertical
            result_split_in_place = false,
            -- stay in current windows (.http file) or change to results window (default)
            stay_in_current_window_after_split = false,
            -- Skip SSL verification, useful for unknown certificates
          skip_ssl_verification = false,
          -- Encode URL before making request
          encode_url = true,
          -- Highlight request on run
          highlight = {
            enabled = true,
            timeout = 150,
          },
          result = {
            -- toggle showing URL, HTTP info, headers at top the of result window
            show_url = true,
            -- show the generated curl command in case you want to launch
            -- the same request via the terminal (can be verbose)
            show_curl_command = false,
            show_http_info = true,
            show_headers = true,
            -- table of curl `--write-out` variables or false if disabled
            -- for more granular control see Statistics Spec
            show_statistics = false,
            -- executables or functions for formatting response body [optional]
            -- set them to false if you want to disable them
            formatters = {
              json = "jq",
              html = function(body)
                return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
              end
            },
          },
          -- Jump to request line on run
          jump_to_request = false,
          env_file = '.env',
          custom_dynamic_variables = {},
          yank_dry_run = true,
          search_back = true,
        })
      end,
      lazy=false,
    },
    {
      'glacambre/firenvim',
      run = function() vim.fn['firenvim#install'](0) end ,
      lazy=false,
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      lazy=false,
    },
    { 
      "hrsh7th/nvim-cmp",
      -- override the options table that is used in the `require("cmp").setup()` call
      opts = function(_, opts)
        -- opts parameter is the default options table
        -- the function is lazy loaded so cmp is able to be required
        local cmp = require "cmp"
        -- modify the mapping part of the table
        opts.mapping["<C-i>"] = cmp.mapping.complete()

        -- return the new table to be used
        return opts
      end,
    },
    {
      "napmn/react-extract.nvim",
      lazy=false,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      lazy=false,
      config = function()
        require'nvim-treesitter.configs'.setup {
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<C-Space>", -- set to `false` to disable one of the mappings
              node_incremental = "n",
              scope_incremental = "m",
              node_decremental = "N",
              scope_decremental = "M",
            },
          },
        }
      end
    },
    { "HiPhish/rainbow-delimiters.nvim", lazy=false},
    { "tpope/vim-fugitive", lazy=false},
    {
      "toggleterm.nvim", 
      opts={

        direction = "vertical",
        size = 80
      }
    },
    { "goolord/alpha-nvim", lazy=false},
    {"ellisonleao/gruvbox.nvim", lazy=false, config = function() 
      require("gruvbox").setup({
        palette_overrides = {
          dark0 = "#111313",
          dark0_hard = "#111313",
          dark1 = "#1c1f1f",
          dark2 = "#222626",
          dark3 = "#333939",
          bright_red = "#f55954",
          bright_green = "#babb56",
          bright_yellow = "#f9bc51",
          bright_blue = "#83a5a8",
          bright_purple = "#d3869b",
          bright_aqua = "#8ec07c",
          bright_orange = "#f38d46",
          neutral_red = "#da341d",
          neutral_green = "#98974a",
          neutral_yellow = "#c7a931",
          neutral_blue = "#457598",
          neutral_purple = "#d17296",
          neutral_aqua = "#689d6a",
          neutral_orange = "#d65d3e",
          faded_red = "#FFF",
          faded_green = "#39540e",
          faded_yellow = "#856614",
          faded_blue = "#033658",
          faded_purple = "#6f2f61",
          faded_aqua = "#225b38",
          faded_orange = "#8e423e",
          gray = "#828389",
        },
        contrast = "hard"
      })
    end},
    -- You can also add new plugins here as well:
    { "prochri/telescope-all-recent.nvim"},
    { "ggandor/leap.nvim", config = function() 
      require('leap').add_default_mappings()
    end, lazy=false },
    { "MattesGroeger/vim-bookmarks", lazy=false },
    { "tom-anders/telescope-vim-bookmarks.nvim", config = function()
      require('telescope').load_extension('vim_bookmarks')
    end },
    { "github/copilot.vim", lazy=false },
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
    { 'alvan/vim-closetag', lazy=false },
    { 'tpope/vim-fugitive', lazy=false },
    { 'FooSoft/vim-argwrap', lazy=false },
    { 'mattn/emmet-vim', lazy=false  },
    { 'ludovicchabant/vim-gutentags', lazy=false  },
    {
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        })
      end,
      lazy=false,
    },
    { 'fatih/vim-go', lazy=false  },
    { 'sbdchd/neoformat', lazy=false  },
    { 'petertriho/nvim-scrollbar', lazy=false   },
    -- All other entries override the setup() call for default plugins
    --
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
      }
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
    formatting = {
      format_on_save = false,
    },
    config = {
      tsserver = {
        single_file_support = false
      }
    }
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
      ["<C-f>"] = { function() 
        -- organize imports
        -- TODO Make this work with other formatters
        vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})
        -- ESLintFixAll
        vim.defer(function() vim.cmd("EslintFixAll") end, 100)
      end },
      -- second key is the lefthand side of the map
      ['<leader>se'] = { function() VisualSelectError() end },
      ["<C-=>"] = { function() neovideScale(0.1) end , desc = "Decrease scale" },
      ["<C-->"] = { function() neovideScale(-0.1) end , desc = "Increase scale" },
      ["<C-s>"] = { ":wa<cr>", desc = "Save File" },
      ["<C-t>"] = { "A // TODO(flatplate)<esc>", desc = "Add todo" },
      ["<C-q>"] = { "<C-w>q", desc = "Close current panel" },
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
      ["<leader>fq"] = { function() require('telescope').extensions.live_grep_args.live_grep_args() end , desc = "Live grep with args" },
      ['<leader>ff'] = { ":Telescope find_files hidden=true<CR>" },
      ['<leader>fb'] = { ":Telescope vim_bookmarks all<CR>" },
      ['<leader>fp'] = { function() require('telescope.builtin').live_grep({ grep_open_files = true }) end,
      desc = "Search in open files" },
      ['<leader>fg'] = {function()
        local path = vim.fn.expand('%:p:h')
        require('telescope.builtin').git_status(getTelescopeOpts(vim.fn.getcwd(), path))
      end ,  desc = "Telescope git diff files" },
      ['<leader>ft'] = { function()
        require('telescope.builtin').git_status({ cwd = vim.fn.expand('%:p:h') })
      end },
      ["<leader>fc"] = { 
        function() require("telescope-live-grep-args.shortcuts").grep_word_under_cursor() end
      },
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
      ['<c-1>'] = { function() require("harpoon.ui").toggle_quick_menu() end },
      ['<leader>gr'] = { function() require('telescope.builtin').lsp_references({layout_strategy='cursor',layout_config={width=0.99, height=0.4}}) end, desc = "Telescope LSP references" }
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
      ['<c-l>'] = {function() 
        -- local rest = require("rest-nvim")

        result = vim.fn["copilot#Accept"]('<CR>')
        -- should be utf-8 decoded
        -- local curl = 'curl http://localhost:5000/accept'

        -- os.execute(curl)
        return result
      end , expr = true, silent = true, noremap = true, replace_keycodes = false },
      ['<c-i>'] ={ function() require('cmp').mapping.complete() end, desc = "Open suggestions" },
    },

    -- Remaps for the refactoring operations currently offered by the refactoring.nvim plugin
    v = {
      ["<leader>re"] = { function(opts) require("react-extract").extract_to_new_file(opts) end },
      ["<leader>rf"] = { function(opts) require("react-extract").extract_to_current_file(opts) end },
      ["<leader>fc"] = { 
        function() require("telescope-live-grep-args.shortcuts").grep_visual_selection() end
      },
      ['<c-cr>'] = { function() vim.lsp.buf.range_code_action() end },
    }
  },

  -- This function is run last
  -- good place to configuring augroups/autocommands and custom filetypes
  polish = function()
    -- Set key binding
    -- Set autocommands
    -- TODO Add autocmd to switch makeprg to "set makeprg=yarn\ tsc\ \\\|\ sed\ 's/(\\(.*\\),\\(.*\\)):/:\\1:\\2:/'\ \\\|\ sed\ 's/@cresta/packages/'\ \\\|\ sed\ 's/:\ src/\\/src/'"
    -- possible also cd into director if the file is in the director repo

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

    vim.cmd([[
    augroup autosave_buffer
    au!
    au FocusLost * :wa
    augroup END
    ]])
  end,

  highlights = {
    init = function()
      local get_hlgroup = require("astronvim.utils").get_hlgroup
      -- get highlights from highlight groups
      local normal = get_hlgroup "Normal"
      local fg, bg = normal.fg, normal.bg
      local bg_alt = get_hlgroup("Visual").bg
      local green = get_hlgroup("String").fg
      local red = get_hlgroup("Error").fg
      -- return a table of highlights for telescope based on colors gotten from highlight groups
      return {
        TelescopeBorder = { fg = bg_alt, bg = bg },
        TelescopeNormal = { bg = bg },
        TelescopePreviewBorder = { fg = bg, bg = bg },
        TelescopePreviewNormal = { bg = bg },
        TelescopePreviewTitle = { fg = bg, bg = green },
        TelescopePromptBorder = { fg = bg_alt, bg = bg_alt },
        TelescopePromptNormal = { fg = fg, bg = bg_alt },
        TelescopePromptPrefix = { fg = red, bg = bg_alt },
        TelescopePromptTitle = { fg = bg, bg = red },
        TelescopeResultsBorder = { fg = bg, bg = bg },
        TelescopeResultsNormal = { bg = bg },
        TelescopeResultsTitle = { fg = bg, bg = bg },
      }
    end
  }
}

return config
