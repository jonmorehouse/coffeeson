require "./bootstrap"
parse = projectRequire "parse"

exports.base_parse_no_opts = (test)->

    parse getFixturePath("base.cson"), (err, obj)->

      p obj
      do test.done






