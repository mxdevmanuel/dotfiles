-- Old statusline
-- w.statusline =
--     "%<%#StatusLineGit#%<%{FugitiveStatusline()} %f %#StatusLine#%h%m%r%=%#StatusLineFt# %y %#StatusLine# %-14.(%l,%c%V%) %P"
local M = {}

function M.setup()
    require('lualine').setup({
        options = {
            theme = 'gruvbox',
            component_separators = {
                left = '|',
                right = '|'
            },
            section_separators = {
                left = '',
                right = ''
            },
            disabled_filetypes = {'NvimTree'}

        },
        sections = {
            lualine_a = {'branch'},
            lualine_b = {'diff', 'filename'},
            lualine_c = {
                {
                    'diagnostics',
                    sources = {'nvim_lsp'}
                }
            },
            -- 'encoding', 'fileformat',
            lualine_x = {'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        }
    })
end

return M
