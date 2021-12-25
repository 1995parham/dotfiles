local gl = require('galaxyline')
local nt = require('nvim-treesitter')
local gls = gl.section

local colors = {
	bg = '#525252',
	black = '#2c2c2c',
	yellow = '#fabd2f',
	cyan = '#00e6e6',
	darkblue = '#081633',
	green = '#afd700',
	orange = '#FF8800',
	purple = '#5d4d7a',
	magenta = '#d16d9e',
	grey = '#c0c0c0',
	blue = '#0087d7',
	red = '#ec5f67'
}

local buffer_not_empty = function()
	if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then return true end
	return false
end

gls.left[1] = {
	FirstElement = {
		provider = function() return '' end,
		highlight = {colors.blue, colors.yellow}
	}
}

gls.left[2] = {
	ViMode = {
		provider = function()
			local alias = {
				n = 'NORMAL',
				i = 'INSERT',
				c = 'COMMAND',
				v = 'VISUAL',
				V = 'VISUAL LINE',
				[''] = 'VISUAL BLOCK'
			}
			return alias[vim.fn.mode()]
		end,
		separator = '|',
		separator_highlight = {colors.black, colors.bg},
		highlight = {colors.orange, colors.bg, 'bold'}
	}
}

gls.left[3] = {
	FileIcon = {
		provider = 'FileIcon',
		condition = buffer_not_empty,
		highlight = {
			require('galaxyline.provider_fileinfo').get_file_icon_color,
			colors.bg
		}
	}
}

gls.left[4] = {
	FileName = {
		provider = {'FileName', 'FileSize'},
		condition = buffer_not_empty,
		separator = '|',
		separator_highlight = {colors.black, colors.bg},
		highlight = {colors.green, colors.bg}
	}
}

gls.left[5] = {
	GitIcon = {
		provider = function() return '   ' end,
		condition = buffer_not_empty,
		highlight = {colors.orange, colors.purple}
	}
}

gls.left[6] = {
	GitBranch = {
		provider = 'GitBranch',
		condition = buffer_not_empty,
		highlight = {colors.grey, colors.purple}
	}
}

local checkwidth = function()
	local squeeze_width = vim.fn.winwidth(0) / 2
	if squeeze_width > 40 then return true end
	return false
end

gls.left[7] = {
	DiffAdd = {
		provider = 'DiffAdd',
		condition = checkwidth,
		icon = ' + ',
		highlight = {colors.green, colors.purple}
	}
}

gls.left[8] = {
	DiffModified = {
		provider = 'DiffModified',
		condition = checkwidth,
		icon = ' ~ ',
		highlight = {colors.orange, colors.purple}
	}
}

gls.left[9] = {
	DiffRemove = {
		provider = 'DiffRemove',
		condition = checkwidth,
		icon = ' - ',
		highlight = {colors.red, colors.purple}
	}
}

gls.left[10] = {
	LeftEnd = {
		provider = function() return '|' end,
		separator = '|',
		separator_highlight = {colors.purple, colors.bg},
		highlight = {colors.purple, colors.purple}
	}
}

gls.left[11] = {
	DiagnosticError = {
		provider = 'DiagnosticError',
		icon = '  ',
		highlight = {colors.red, colors.bg}
	}
}

gls.left[12] = {
	DiagnosticWarn = {
		provider = 'DiagnosticWarn',
		icon = '  ',
		highlight = {colors.blue, colors.bg}
	}
}

gls.left[13] = {
	CoC = {
		provider = function() return vim.fn['coc#status']() end,
		highlight = {colors.orange, colors.bg}
	}
}

gls.right[1] = {
	FileFormat = {
		provider = 'FileFormat',
		separator = ' | ',
		separator_highlight = {colors.black, colors.bg},
		highlight = {colors.cyan, colors.bg}
	}
}

gls.right[2] = {
	LineInfo = {
		provider = 'LineColumn',
		separator = ' | ',
		separator_highlight = {colors.black, colors.bg},
		highlight = {colors.grey, colors.bg}
	}
}

gls.right[3] = {
	PerCent = {
		provider = 'LinePercent',
		separator = '|',
		separator_highlight = {colors.black, colors.bg},
		highlight = {colors.grey, colors.bg}
	}
}
gls.right[4] = {
	ScrollBar = {provider = 'ScrollBar', highlight = {colors.yellow, colors.bg}}
}

gls.right[5] = {
	BufferType = {
		provider = 'FileTypeName',
		separator = '|',
		separator_highlight = {colors.black, colors.bg},
		highlight = {colors.grey, colors.bg}
	}
}

gls.right[6] = {
	TreeSitter = {
		provider = function()
			return nt.statusline({
				indicator_size = 100,
				type_patterns = {'class', 'function', 'method'},
				transform_fn = function(line) return line:gsub('%s*[%[%(%{]*%s*$', '') end,
				separator = ' -> '
			})
		end,
		separator = '|',
		separator_highlight = {colors.black, colors.bg},
		highlight = {colors.grey, colors.bg}
	}
}


gls.short_line_right[1] = {
	BufferIcon = {
		provider = 'BufferIcon',
		separator = '|',
		separator_highlight = {colors.purple, colors.bg},
		highlight = {colors.grey, colors.purple}
	}
}
