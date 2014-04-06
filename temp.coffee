parse = require './lib/parse'
fixturePath = 'test/fixtures/base.cson'
global.p = console.log

parse fixturePath, (err, obj)->

  console.log err
  console.log obj

