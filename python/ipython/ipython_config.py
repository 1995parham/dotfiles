# Configuration file for ipython.

# ------------------------------------------------------------------------------
# InteractiveShellApp(Configurable) configuration
# ------------------------------------------------------------------------------
## A Mixin for applications that start InteractiveShell instances.
#
#      Provides configurables for loading extensions and executing files
#      as part of configuring a Shell environment.
#
#      The following methods should be called by the :meth:`initialize` method
#      of the subclass:
#
#        - :meth:`init_path`
#        - :meth:`init_shell` (to be implemented by the subclass)
#        - :meth:`init_gui_pylab`
#        - :meth:`init_extensions`
#        - :meth:`init_code`


## Configure matplotlib for interactive use with
#          the default matplotlib backend.
#  Choices: any of ['auto', 'agg', 'gtk', 'gtk3', 'gtk4', 'inline', 'ipympl', 'nbagg', 'notebook', 'osx', 'pdf', 'ps', 'qt', 'qt4', 'qt5', 'qt6', 'svg', 'tk', 'widget', 'wx'] (case-insensitive) or None
#  Default: None
c.InteractiveShellApp.matplotlib = "auto"

## Pre-load matplotlib and numpy for interactive use,
#          selecting a particular matplotlib backend and loop integration.
#  Choices: any of ['auto', 'agg', 'gtk', 'gtk3', 'gtk4', 'inline', 'ipympl', 'nbagg', 'notebook', 'osx', 'pdf', 'ps', 'qt', 'qt4', 'qt5', 'qt6', 'svg', 'tk', 'widget', 'wx'] (case-insensitive) or None
#  Default: None
# c.InteractiveShellApp.pylab = None

## If true, IPython will populate the user namespace with numpy, pylab, etc.
#          and an ``import *`` is done from numpy and pylab, when using pylab mode.
#
#          When False, pylab mode should not import any names into the user
#  namespace.
#  Default: True
# c.InteractiveShellApp.pylab_import_all = True

## Reraise exceptions encountered loading IPython extensions?
#  Default: False
# c.InteractiveShellApp.reraise_ipython_extension_failures = False

# ------------------------------------------------------------------------------
# Application(SingletonConfigurable) configuration
# ------------------------------------------------------------------------------
## This is an application.

## The date format used by logging formatters for %(asctime)s
#  Default: '%Y-%m-%d %H:%M:%S'
# c.Application.log_datefmt = '%Y-%m-%d %H:%M:%S'

## The Logging format template
#  Default: '[%(name)s]%(highlevel)s %(message)s'
# c.Application.log_format = '[%(name)s]%(highlevel)s %(message)s'

## Set the log level by value or name.
#  Choices: any of [0, 10, 20, 30, 40, 50, 'DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL']
#  Default: 30
# c.Application.log_level = 30

## Instead of starting the Application, dump configuration to stdout
#  Default: False
# c.Application.show_config = False

## Instead of starting the Application, dump configuration to stdout (as JSON)
#  Default: False
# c.Application.show_config_json = False

# ------------------------------------------------------------------------------
# BaseIPythonApplication(Application) configuration
# ------------------------------------------------------------------------------
## IPython: an enhanced interactive Python shell.

# ------------------------------------------------------------------------------
# TerminalIPythonApp(BaseIPythonApplication, InteractiveShellApp) configuration
# ------------------------------------------------------------------------------

## Whether to install the default config files into the profile dir.
#  See also: BaseIPythonApplication.copy_config_files
# c.TerminalIPythonApp.copy_config_files = False

## Whether to display a banner upon starting IPython.
#  Default: True
c.TerminalIPythonApp.display_banner = True

# ------------------------------------------------------------------------------
# InteractiveShell(SingletonConfigurable) configuration
# ------------------------------------------------------------------------------
## An enhanced, interactive shell for Python.

## 'all', 'last', 'last_expr' or 'none', 'last_expr_or_assign' specifying which
#  nodes should be run interactively (displaying output from expressions).
#  Choices: any of ['all', 'last', 'last_expr', 'none', 'last_expr_or_assign']
#  Default: 'last_expr'
# c.InteractiveShell.ast_node_interactivity = 'last_expr'

## A list of ast.NodeTransformer subclass instances, which will be applied to
#  user input before code is run.
#  Default: []
# c.InteractiveShell.ast_transformers = []

## Automatically run await statement in the top level repl.
#  Default: True
# c.InteractiveShell.autoawait = True

## Make IPython automatically call any callable object even if you didn't type
#  explicit parentheses. For example, 'str 43' becomes 'str(43)' automatically.
#  The value can be '0' to disable the feature, '1' for 'smart' autocall, where
#  it is not applied if there are no more arguments on the line, and '2' for
#  'full' autocall, where all callable objects are automatically called (even if
#  no arguments are present).
#  Choices: any of [0, 1, 2]
#  Default: 0
# c.InteractiveShell.autocall = 0

## Autoindent IPython code entered interactively.
#  Default: True
# c.InteractiveShell.autoindent = True

## Enable magic commands to be called without the leading %.
#  Default: True
# c.InteractiveShell.automagic = True

## The part of the banner to be printed before the profile
#  Default: "Python 3.10.2 (main, Jan 15 2022, 19:56:27) [GCC 11.1.0]\nType 'copyright', 'credits' or 'license' for more information\nIPython 8.0.1 -- An enhanced Interactive Python. Type '?' for help.\n"
# c.InteractiveShell.banner1 = "Python 3.10.2 (main, Jan 15 2022, 19:56:27) [GCC 11.1.0]\nType 'copyright', 'credits' or 'license' for more information\nIPython 8.0.1 -- An enhanced Interactive Python. Type '?' for help.\n"

## The part of the banner to be printed after the profile
#  Default: ''
c.InteractiveShell.banner2 = r"""
 _  ___   ___  ____                   _
/ |/ _ \ / _ \| ___| _ __   __ _ _ __| |__   __ _ _ __ ___
| | (_) | (_) |___ \| '_ \ / _` | '__| '_ \ / _` | '_ ` _ \
| |\__, |\__, |___) | |_) | (_| | |  | | | | (_| | | | | | |
|_|  /_/   /_/|____/| .__/ \__,_|_|  |_| |_|\__,_|_| |_| |_|
                    |_|
"""

## Use colors for displaying information about objects. Because this information
#  is passed through a pager (like 'less'), and some pagers get confused with
#  color codes, this capability can be turned off.
#  Default: True
# c.InteractiveShell.color_info = True

## Set the color scheme (NoColor, Neutral, Linux, or LightBG).
#  Choices: any of ['Neutral', 'NoColor', 'LightBG', 'Linux'] (case-insensitive)
#  Default: 'Neutral'
c.InteractiveShell.colors = "Linux"

#  Default: False
# c.InteractiveShell.debug = False

## Don't call post-execute functions that have failed in the past.
#  Default: False
# c.InteractiveShell.disable_failing_post_execute = False

## If True, anything that would be passed to the pager
#          will be displayed as regular output instead.
#  Default: False
# c.InteractiveShell.display_page = False

## (Provisional API) enables html representation in mime bundles sent to pagers.
#  Default: False
# c.InteractiveShell.enable_html_pager = False

## Total length of command history
#  Default: 10000
# c.InteractiveShell.history_length = 10000

## The number of saved history entries to be loaded into the history buffer at
#  startup.
#  Default: 1000
# c.InteractiveShell.history_load_length = 1000

#  Default: ''
# c.InteractiveShell.ipython_dir = ''

## Start logging to the given file in append mode. Use `logfile` to specify a log
#  file to **overwrite** logs to.
#  Default: ''
# c.InteractiveShell.logappend = ''

## The name of the logfile to use.
#  Default: ''
# c.InteractiveShell.logfile = ''

## Start logging to the default log file in overwrite mode. Use `logappend` to
#  specify a log file to **append** logs to.
#  Default: False
# c.InteractiveShell.logstart = False

## Select the loop runner that will be used to execute top-level asynchronous
#  code
#  Default: 'IPython.core.interactiveshell._asyncio_runner'
# c.InteractiveShell.loop_runner = 'IPython.core.interactiveshell._asyncio_runner'

#  Choices: any of [0, 1, 2]
#  Default: 0
# c.InteractiveShell.object_info_string_level = 0

## Automatically call the pdb debugger after every exception.
#  Default: False
# c.InteractiveShell.pdb = False

#  Default: False
# c.InteractiveShell.quiet = False

#  Default: '\n'
# c.InteractiveShell.separate_in = '\n'

#  Default: ''
# c.InteractiveShell.separate_out = ''

#  Default: ''
# c.InteractiveShell.separate_out2 = ''

## Show rewritten input, e.g. for autocall.
#  Default: True
# c.InteractiveShell.show_rewritten_input = True

## Enables rich html representation of docstrings. (This requires the docrepr
#  module).
#  Default: False
# c.InteractiveShell.sphinxify_docstring = False

#  Default: True
# c.InteractiveShell.wildcards_case_sensitive = True

## Switch modes for the IPython exception handlers.
#  Choices: any of ['Context', 'Plain', 'Verbose', 'Minimal'] (case-insensitive)
#  Default: 'Context'
# c.InteractiveShell.xmode = 'Context'

# ------------------------------------------------------------------------------
# TerminalInteractiveShell(InteractiveShell) configuration
# ------------------------------------------------------------------------------
##
#  See also: InteractiveShell.ast_node_interactivity
# c.TerminalInteractiveShell.ast_node_interactivity = 'last_expr'

##
#  See also: InteractiveShell.ast_transformers
# c.TerminalInteractiveShell.ast_transformers = []

## Automatically add/delete closing bracket or quote when opening bracket or
#  quote is entered/deleted. Brackets: (), [], {} Quotes: '', ""
#  Default: False
# c.TerminalInteractiveShell.auto_match = False

##
#  See also: InteractiveShell.autoawait
# c.TerminalInteractiveShell.autoawait = True

##
#  See also: InteractiveShell.autocall
# c.TerminalInteractiveShell.autocall = 0

## Autoformatter to reformat Terminal code. Can be `'black'` or `None`
#  Default: 'black'
c.TerminalInteractiveShell.autoformatter = "black"

##
#  See also: InteractiveShell.autoindent
# c.TerminalInteractiveShell.autoindent = True

##
#  See also: InteractiveShell.automagic
# c.TerminalInteractiveShell.automagic = True

## The part of the banner to be printed before the profile
#  See also: InteractiveShell.banner1
# c.TerminalInteractiveShell.banner1 = "Python 3.10.2 (main, Jan 15 2022, 19:56:27) [GCC 11.1.0]\nType 'copyright', 'credits' or 'license' for more information\nIPython 8.0.1 -- An enhanced Interactive Python. Type '?' for help.\n"

## The part of the banner to be printed after the profile
#  See also: InteractiveShell.banner2
# c.TerminalInteractiveShell.banner2 = ''

##
#  See also: InteractiveShell.cache_size
# c.TerminalInteractiveShell.cache_size = 1000

##
#  See also: InteractiveShell.color_info
# c.TerminalInteractiveShell.color_info = True

## Set the color scheme (NoColor, Neutral, Linux, or LightBG).
#  See also: InteractiveShell.colors
# c.TerminalInteractiveShell.colors = 'Neutral'

## Set to confirm when you try to exit IPython with an EOF (Control-D in Unix,
#  Control-Z/Enter in Windows). By typing 'exit' or 'quit', you can force a
#  direct exit without any confirmation.
#  Default: True
# c.TerminalInteractiveShell.confirm_exit = True

## Options for displaying tab completions, 'column', 'multicolumn', and
#  'readlinelike'. These options are for `prompt_toolkit`, see `prompt_toolkit`
#  documentation for more information.
#  Choices: any of ['column', 'multicolumn', 'readlinelike']
#  Default: 'multicolumn'
# c.TerminalInteractiveShell.display_completions = 'multicolumn'

## Shortcut style to use at the prompt. 'vi' or 'emacs'.
#  Default: 'emacs'
c.TerminalInteractiveShell.editing_mode = "vi"

## Add shortcuts from 'emacs' insert mode to 'vi' insert mode.
#  Default: True
c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = True

## Enable vi (v) or Emacs (C-X C-E) shortcuts to open an external editor. This is
#  in addition to the F2 binding, which is always enabled.
#  Default: False
c.TerminalInteractiveShell.extra_open_editor_shortcuts = True
