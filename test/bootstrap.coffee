path = require 'path'

# declare project path
projectDirectory = path.resolve path.join __dirname, ".."

# global function for requiring a project path
global.projectRequire = (_path)->
  
  return require path.join projectDirectory, "src", _path
  
# some helpers while debugging / building project
global.p = console.log



