require "./bootstrap"
parse = projectRequire "parse"

exports.test = (test)->

  p module.name

  do test.done 


