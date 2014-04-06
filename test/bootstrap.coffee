path = require 'path'
fs = require 'fs'

# declare project path
projectDirectory = path.resolve path.join __dirname, ".."

# global function for requiring a project path
global.projectRequire = (_path)->
  return require path.join projectDirectory, "lib", _path

global.getFixturePath = (fixture)->

  # if fixture has a json ending then return the json version
  return path.join __dirname, "fixtures", if path.extname(fixture) then fixture else "#{fixture}.cson"

# get a fixture
global.getFixture = (fixture, convertJson, cb)->

  # handle callback / optional second argument
  if not cb? 
    cb = convertJson
    convertJson = true

  _path = getFixturePath fixture

  # require json if given json and a convertJson flag
  if path.extname(_path) == ".json" and convertJson
    data = require _path 
    cb data
  else
    fs.readFile _path, "utf-8", (err, data)->
      return process.exit 1 if err
      cb data

# some helpers while debugging / building project
global.p = console.log


