require 'sinatra'
require_relative File.join('config', "shared.rb")

require 'json'
require 'curl'

get '/' do
  haml :index, :locals => {:env => ENV["RACK_ENV"], :medal_count => medal_count}
end

get '/no_medal' do
  result = medal_count
  countries_wo_medals = []

  countries = Country.all
  countries.each do |country|
    countries_wo_medals << country if !has_country?(result, country.url_name)
  end

  haml :no_medal, :locals => { :countries => countries_wo_medals }
end

get '/medal_by_continent' do
  result = medal_count

  continent_medals = {
    'africa' => {'bronze' => 0, 'silver' => 0, 'gold' => 0, 'total' => 0 },
    'asia' => { 'bronze' => 0, 'silver' => 0, 'gold' => 0, 'total' => 0 },
    'oceania' => { 'bronze' => 0, 'silver' => 0, 'gold' => 0, 'total' => 0 },
    'americas' => { 'bronze' => 0, 'silver' => 0, 'gold' => 0, 'total' => 0 },
    'europe' => { 'bronze' => 0, 'silver' => 0, 'gold' => 0, 'total' => 0 }
  }

  result.each do |country|
    continent = country['continent']
    continent_medals[continent]['bronze'] = continent_medals[continent]['bronze'] + country['bronze'].to_i
    continent_medals[continent]['silver'] = continent_medals[continent]['silver'] + country['silver'].to_i
    continent_medals[continent]['gold'] = continent_medals[continent]['gold'] + country['gold'].to_i
    continent_medals[continent]['total'] = continent_medals[continent]['total'] +
      country['bronze'].to_i +
      country['silver'].to_i +
      country['gold'].to_i
  end

  continent_medals_array = []
  continent_medals.each { |k, v| continent_medals_array << v.merge!({ 'continent' => k }) }
  continent_medals_array.sort_by! { |o| -o['total'] }

  haml :medal_count_by_continent, :locals => { :continent_medals => continent_medals_array }
end

def medal_count
  curl = Curl::Easy.new("http://apify.heroku.com/api/olympics2012_medals.json")
  curl.perform
  result = JSON.parse(curl.body_str)

  result.each do |country|
    country["url"].slice!("/country/")
    country["url"].slice!("/medals/index.html")
    country.merge!({"continent" => Country.first(url_name: country["url"]).continent})
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
