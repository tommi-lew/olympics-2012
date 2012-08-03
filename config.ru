#$LOAD_PATH.unshift(File.dirname(__FILE__))
require './web.rb'
run Sinatra::Application
