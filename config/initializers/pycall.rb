require 'pycall/import'
PyCall.sys.path.append('./env/lib/python3.9/site-packages') # Update `python3.x` with your Python version
PyCall.exec('import sys; sys.executable = "./env/bin/python"')
