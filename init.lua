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


local config = {
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
  colorscheme = "tundra",

  -- Override highlight groups in any theme
  highlights = {
    -- duskfox = { -- a table of overrides
    --   Normal = { bg = "#000000" },
    -- },
    default_theme = function(highlights) -- or a function that returns one
      local C = require "default_theme.colors"

      highlights.Normal = { fg = C.fg, bg = C.bg }
      return highlights
    end,
  },

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
      relativenumber = true, -- sets vim.opt.relativenumber
      ignorecase = true,
      guifont = "JetBrainsMono Nerd Font Mono:h12",
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      tabstop = 4,
      shiftwidth = 4,
      expandtab = true,
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
      aerial = true,
      beacon = false,
      bufferline = true,
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
    telescope_select = true,
  },

  -- Configure plugins
  -- #plugins
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    init = {
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },

      -- You can also add new plugins here as well:
      {
        "cshuaimin/ssr.nvim",
        module = "ssr",
        -- Calling setup is optional.
        config = function()
          require("ssr").setup {
            min_width = 50,
            min_height = 5,
            keymaps = {
              close = "q",
              next_match = "n",
              prev_match = "N",
              replace_all = "<leader><cr>",
            },
          }
        end
      },
      { 'alvan/vim-closetag' },
      { 'tpope/vim-fugitive' },
      {
        'hkupty/iron.nvim',
        config = function() 

          local iron = require("iron.core")
          local view = require("iron.view")
          iron.setup {
            config = {
              -- Whether a repl should be discarded or not
              scratch_repl = true,
              -- Your repl definitions come here
              repl_definition = {
                sh = {
                  command = {"zsh"}
                }
              },
              -- How the repl window will be displayed
              -- See below for more information
              repl_open_cmd = view.split(8),
            },
            -- Iron doesn't set keymaps by default anymore.
            -- You can set them here or manually add keymaps to the functions in iron.core
            keymaps = {
              send_motion = "<space>ii",
              visual_send = "<space>ii",
              send_file = "<space>if",
              send_line = "<space>i<CR>",
              send_mark = "<space>im",
              mark_motion = "<space>mc",
              mark_visual = "<space>mc",
              remove_mark = "<space>md",
              cr = "<space>s<cr>",
              interrupt = "<space>s<space>",
              exit = "<space>sq",
              clear = "<space>cl",
            },
            -- If the highlight is on, you can change how it looks
            -- For the available options, check nvim_set_hl
            highlight = {
              italic = true
            }
          }


        end,
      },
      { 'FooSoft/vim-argwrap' },
      {
        "ThePrimeagen/refactoring.nvim",
        requires = {
          {"nvim-lua/plenary.nvim"},
          {"nvim-treesitter/nvim-treesitter"}
        }
      },
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
          overwrite = {
            colors = {},
            highlights = {},
          },
        })
      end

    },
    { 'mattn/emmet-vim' },
    -- { 'MunifTanjim/prettier.nvim' },
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
    { 'bluz71/vim-nightfly-guicolors' },
    { 'chentoast/marks.nvim' },
    { 'fatih/vim-go' },
    -- { 'sbdchd/neoformat' },
    -- { 'petertriho/nvim-scrollbar'  }
    -- { "andweeb/presence.nvim" },
    -- {
      --   "ray-x/lsp_signature.nvim",
      --   event = "BufRead",
      --   config = function()
        --     require("lsp_signature").setup()
        --   end,
        -- },
      },
    -- All other entries override the setup() call for default plugins
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
                vim.cmd("EslintFixAll")
                -- vim.lsp.buf.format({ name = "eslint" }) -- works too
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
        -- if client.resolved_capabilities.document_formatting then
        --   vim.api.nvim_create_autocmd('BufWritePre', {
        --     pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
        --     command = 'EslintFixAll',
        --     group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
        --   })
        -- end
      end
      return config -- return final config table
    end,
    ["neo-tree"] = function(config) 
      -- TODO Add keybinding for jump to last open buffer location in tree, and disable auto jumping
      -- Search in children of directory under cursor
      config.filesystem.window = {
        mappings = {
          ["tf"] = "telescope_find",
          ["tg"] = "telescope_grep"
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
      ["<C-s>"] = { ":w!<cr>", desc = "Save File" },
      ["<C-p>"] = { "\"qp", desc = "Paste from register q" },
      ["<C-y>"] = { "\"qy", desc = "Copy to register q" },
      ['<c-cr>'] = { function() vim.lsp.buf.code_action() end },
      ['<c-s-tab>'] = { function() require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true }) end },
      ['<c-tab>'] = { ":b#<cr>" },
      ['<c-`>'] = { function() require('telescope.builtin').marks({ sort_lastused = true }) end },
      ['<leader>a'] = {":ArgWrap<cr>"},
      ['<leader>ff'] = {":Telescope find_files hidden=true<CR>"},
      ['<leader>fi'] = { function()
          vim.cmd('noau normal! "zyiw"')
          require('telescope.builtin').find_files({search_file = vim.fn.getreg("z")})
        end },
      ['<leader>fr'] = {":Telescope resume<CR>"},
      ['<leader>gl'] = {":Git blame<CR>"},
      ['gv'] = {":vsplit<CR>gd"},
      ['<leader>sr'] = {'yiw:%s/<C-R>*'}
      -- TODO Some keybinding for search and replace word under cursor: 
      -- ['<c-g>'] = {"<space>gg"}, I tried to use c-g for opening the lazy git window because escaping inside the window is tricky
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
    i = {
      ["<C-p>"] = { "<esc>:Telescope oldfiles<CR>", desc = "Save File" },
      ['<c-s-tab>'] = { function() require('telescope.builtin').buffers({ sort_lastused = true, ignore_current_buffer = true }) end },
      ['<c-tab>'] = { "<esc>:b#<cr>a" },
      -- ['<c-g>'] = {"<esc>gg"},
    },

-- Remaps for the refactoring operations currently offered by the refactoring.nvim plugin
    v = {
      [ "<leader>re" ] = { function() require('refactoring').refactor('Extract Function') end },
      [ "<leader>rf" ] = { function() require('refactoring').refactor('Extract Function To File') end},
      [ "<leader>rv" ] = { function() require('refactoring').refactor('Extract Variable') end},
      [ "<leader>ri" ] = { function() require('refactoring').refactor('Inline Variable') end},
      [ "<leader>fc" ] = { function() 
        vim.cmd('noau visual! "zy"')
        require('telescope.builtin').grep_string({search = vim.fn.getreg("z")})
      end },
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
  end,
}

return config
