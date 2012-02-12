{ exec, spawn } = require 'child_process'
log = console.log

task 'build', ->
  tar = exec 'tar cvf - s3fs/* | gzip > s3fs.tar.gz'
  tar.stdout.on 'data', (data) -> log data.toString()
  tar.stderr.on 'data', (data) -> log data.toString()
  
  