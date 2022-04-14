local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

-- These two are optional and provide syntax highlighting
-- for Neorg tables and the @document.meta tag
parser_configs.norg_meta = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = { "src/parser.c" },
        branch = "main"
    },
}

parser_configs.norg_table = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = { "src/parser.c" },
        branch = "main"
    },
}

require('nvim-treesitter.configs').setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = { "lua", "go", "rust", "c", "bash", "json", "yaml", "python", "javascript", "cpp", "norg", "norg_meta", "norg_table" },
    -- list of parsers to ignore installing
    ignore_install = {},
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "yaml" }, -- list of language that will be disabled
    },
    incremental_selection = {enable = true},
    indent = {enable = true}
}
