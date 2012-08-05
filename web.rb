require 'sinatra'
require_relative File.join('config', "shared.rb")

require 'json'
require 'curl'

get '/' do
  curl = Curl::Easy.new("http://apify.heroku.com/api/olympics2012_medals.json")
  curl.perform
  result = curl.body_str

  json_result = JSON.parse(result)

  haml :index, :locals => {:json_result => json_result}
end
