require 'irb/completion'
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

require 'rubygems'
require 'wirble'

# start wirble (with color)
Wirble.init
Wirble.colorize
