c.TerminalIPythonApp.display_banner = True
c.InteractiveShellApp.log_level = 20

c.InteractiveShellApp.exec_files = ["fancy.ipy"]
c.InteractiveShell.colors = "Linux"
c.InteractiveShell.xmode = "Context"
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.editor = "emax"
c.InteractiveShellApp.exec_lines = []
c.InteractiveShellApp.exec_lines.append("%load_ext autoreload")
c.InteractiveShellApp.exec_lines.append("%autoreload 2")
c.InteractiveShellApp.exec_lines = ["import importlib"]

c.PrefilterManager.multi_line_specials = True

c.AliasManager.user_aliases = [("la", "ls -al")]
