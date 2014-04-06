nodeunit = require 'nodeunit'

task "test", "Run all tests", ->

  reporter = nodeunit.reporters.verbose
  reporter.run ["test"]
   
task "debug", "Temporary development helper", ->
  
  require './test/bootstrap'
  parse = projectRequire 'parse'
  parse getFixturePath("json_require.cson"), (err, obj)->

    p err
    p obj




