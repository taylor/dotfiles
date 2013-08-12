require 'rubygems'
require 'irb/completion'
require 'pp'
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

begin
  # start wirble (with color)
  require 'wirble'
  Wirble.init(:history_size => 5000)
  Wirble.colorize
rescue LoadError => err
  $stderr.puts "Couldn't load Wirble: #{err}"
end

begin
  IRB.conf[:AUTO_INDENT]=true
rescue TypeError
  $stderr.puts "Your IRB is strange..."
end
