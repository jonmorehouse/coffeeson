require "./bootstrap"
parse = projectRequire "parse"
fs = require "fs"

exports.baseParse = (test)->

  parse getFixturePath("base.cson"), (err, obj)->
    test.equal err, null
    test.notEqual obj, null
    getFixture "base.json", (jsonObj)->
      test.deepEqual obj, jsonObj
      do test.done

exports.parseEvaluation = (test)->
  
  csonString = """
    HOME: process.env.HOME
  """
  fs.writeFile "temp.cson", csonString, (err)->
    parse "temp.cson", (err, obj)->
      test.equal err, null
      test.equal obj.HOME, process.env.HOME
      fs.unlink "temp.cson", (err)->
        do test.done

exports.parseWithRequirements = (test)->

  parse getFixturePath("require.cson"), (err, obj)->
    test.equal err, null
    test.notEqual obj, null
    getFixture "require.json", (jsonObj)->
      test.deepEqual obj, jsonObj
      do test.done

