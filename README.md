[![Build Status](http://img.shields.io/travis/pikesley/csv_on_the_web.svg?style=flat-square)](https://travis-ci.org/pikesley/csv_on_the_web)
[![Dependency Status](http://img.shields.io/gemnasium/pikesley/csv_on_the_web.svg?style=flat-square)](https://gemnasium.com/pikesley/csv_on_the_web)
[![Coverage Status](http://img.shields.io/coveralls/pikesley/csv_on_the_web.svg?style=flat-square)](https://coveralls.io/r/pikesley/csv_on_the_web)
[![Code Climate](http://img.shields.io/codeclimate/github/pikesley/csv_on_the_web.svg?style=flat-square)](https://codeclimate.com/github/pikesley/csv_on_the_web)
[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://pikesley.mit-license.org)

# How does CSV On The Web work?

An investigation of [this](https://www.w3.org/TR/tabular-data-primer/) using tomatoes and hats

Using [this hacked branch of csvlint.rb](https://github.com/theodi/csvlint.rb/tree/baffled-by-csvw) I was able to get [csv2json](https://github.com/theodi/csv2json) (via the magic of [jq](https://stedolan.github.io/jq/tutorial/)) to pull some JSON out of this:

    [{~/Github/CSVOTW/csv2json} <2.3.1> (master) ⚡] ➔ ./bin/csv2json --dump-errors --schema http://csv-on-the-web.herokuapp.com/data/tomatoes.csv-metadata.json http://csv-on-the-web.herokuapp.com/data/tomatoes | tail -1 | jq '.'

    [
      {
        "common_name": "ildi",
        "botanical name": "Solanum lycopersicum",
        "tomato_type": "cordon"
      },
      {
        "common_name": "black cherry",
        "botanical name": "Lycopersicon esculentum",
        "tomato_type": "cordon"
      },
      {
        "common_name": "golden sunrise",
        "botanical name": "Solanum lycopersicum",
        "tomato_type": "cordon"
      },
      {
        "common_name": "sungold",
        "botanical name": "Lycopersicon esculentum",
        "tomato_type": "cordon"
      },
      {
        "common_name": "orange fizz",
        "botanical name": "Lycopersicon esculentum",
        "tomato_type": "cordon"
      },
      {
        "type": "cordon",
        "also called": "indeterminate",
        "description": "grows very tall"
      },
      {
        "type": "bush",
        "also called": "determinate",
        "description": "does not require pruning"
      }
    ]

(we're `tail -1`-ing there because csv2json is throwing bogus-looking errors about `no_encoding`)

## Further steps

* Add metadata so csv2json builds structured JSON at the client end
* Fix csv2json so it supplies an `Accept` header in order to make better use pf the `Link` header on this end
