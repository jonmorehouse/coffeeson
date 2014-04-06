coffee = require 'coffee-script'
path = require 'path'
fs = require 'fs'
async = require 'async'

module.exports = (path, opts, cb)->

  # initialize queue worker
  q = async.queue (task, cb)->

    p "HELLO FROM QUEUE"
    do cb

  # final callback 
  q.drain = ->
    # object is finished!
    p "drained"
    cb null, {}

  # parse an individual file
  parseFile = (path, opts, cb)->
    fs.readFile path, 'utf-8', (err, data)->
      return cb err if err
      # convert the src to coffee-script
      try
        obj = p coffee.eval str, opts
        for key of result
          if typeof obj[key] == 'object'
            # queue up element as needed!
            q.push {obj: obj[key]}, (err)->
              return cb err if err
      catch err
        return cb err if err

  parseFile path, {}, (err)->
    cb err
      

