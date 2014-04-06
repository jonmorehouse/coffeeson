coffee = require 'coffee-script'
path = require 'path'
fs = require 'fs'
async = require 'async'

# load a file
loadFile = (filepath, cb)->
  fs.readFile filepath, 'utf-8', (err, str)->
    return cb err if err

    # declare loader functions
    loadCson = ->
      try
        obj = coffee.eval str, {}
      catch err
        return cb err if err
      cb null, obj
    loadJson = ->
      try
        obj = JSON.loads str
      catch err
        return cb err if err
      cb null, obj

    # switch for handling different files
    switch path.extname filepath
      when ".json" then do loadJson
      when ".cson" then do loadCson
      else
        return cb err

# merge obj onto baseObj recursively
mergeObjects = (obj, baseObj, opts)->  

  # will return synchronously
  if not opts? or not opts.extend?
    opts = {extend:true}

  for key of baseObj
    # the baseObj key was overwritten
    if obj[key]? and not typeof obj[key] == "object"
      continue
    else if not obj[key]?
      obj[key] = baseObj[key]
    else if typeof baseObj[key] == "object"
      # merge (recursively) the baseObj and the newObj
      extend true, obj[key], baseObj[key]

module.exports = (path, cb)->
  
  # master object that gets handled
  obj = {require: path}
  q = null

  # handle errors within the local scope
  errorHandler = (err)->
    return cb err if err

  # queue up jobs for an object
  queuer = (obj)->
    for key of obj
      if typeof obj[key] == "object"
        q.push obj[key], errorHandler

  # create recurser function
  recurser = (obj, cb)->
    
    if obj.require?
      # handle the key
      value = obj.require
      # handle the extension
      if typeof value == "object"
        requirePath = value.path
        extend = if value.extend? then value.extend else true 
      else 
        requirePath = value
        extend = true
      # load requirements file and grab the object it returns
      loadFile requirePath, (err, newObj)->
        return cb err if err
        # now merge ... according to our rules
        mergeObjects obj, newObj, {extend: extend}
        delete obj.require
        queuer obj
        do cb
    else
      queuer obj
      do cb

  # initialize queue
  q = async.queue recurser, 4
  q.drain = ->
    cb null, obj
  # start the first 
  q.push obj

