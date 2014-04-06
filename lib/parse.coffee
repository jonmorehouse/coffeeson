coffee = require 'coffee-script'
path = require 'path'
fs = require 'fs'
async = require 'async'

module.exports = (path, opts, cb)->

  if not cb?
    cb = opts
    opts = {}

  # initialize global variables
  obj = {}

  # initialize queue worker
  q = async.queue (obj, cb)->
    # now lets look for any required keys etc
    p obj
    for key of obj
      p key

  # final callback 
  q.drain = ->
    # object is finished!
    cb null, obj

  # parse an individual file
  parseFile = (path, obj, cb)->
    # process 
    fs.readFile path, 'utf-8', (err, str)->
      return cb err if err

      # convert the src to coffee-script
      try
        newObj = coffee.eval str, opts
      catch err
        return cb err if err

      # now lets push the current element onto the stack as needed
      for key of newObj
        # copy the key to the parent
        obj[key] = newObj[key]
        # if we have an object - pass the object to the worker to be dealt with!
        if typeof obj[key] == "object"
          # create a task and handle errors
          q.push obj[key], (err)->
            return cb err if err
        # whether or not the queue has been started / job submitted
        if not q.started
          return cb null, obj

  # kill everything if we get an error!
  parseFile path, obj, (err, obj)->
    # stop the queue
    return cb err if err
    cb null, obj

