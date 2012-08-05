require 'sinatra'
require_relative File.join('config', "shared.rb")

require 'json'
require 'curl'

get '/' do
  haml :index, :locals => {:medal_count => medal_count}
end

get '/no_medal' do
  result = medal_count
  countries_wo_medals = []

  countries = Country.all
  countries.each do |country|
    countries_wo_medals << country if !has_country?(result, country.url_name)
  end

  haml :no_medals, :locals => { :countries => countries_wo_medals }
end

def medal_count
  curl = Curl::Easy.new("http://apify.heroku.com/api/olympics2012_medals.json")
  curl.perform
  result = JSON.parse(curl.body_str)

  result.each do |country|
    country["url"].slice!("/country/")
    country["url"].slice!("/medals/index.html")
  end
  result
end

def has_country?(medal_count, country_url_name)
  result = false
  medal_count.each do |country_w_medal|
    if country_w_medal["url"] == country_url_name
      result = true
      break
    end
  end
  result
end
