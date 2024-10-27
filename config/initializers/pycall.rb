require 'pycall/import'
include PyCall::Import

PyCall.sys.path.append(File.expand_path("../../../app/python", __FILE__))
PyCall.exec('import sys; sys.executable = "./env/bin/python"')
PyCall.exec("import sys; sys.path.append('/Users/khanderz/Documents/projects/pharmdv3/env/lib/python3.9/site-packages')")