ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))

RACK_ENV ||= ENV["RACK_ENV"] || "development"

require 'bundler/setup'
require 'sinatra'
require "sinatra/reloader" if development?
require 'haml'
require 'data_mapper'

Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../models/**/*.rb"].each { |f| require f }

dbconfig = YAML.load(ERB.new(File.read("#{File.dirname(__FILE__)}/database.yml")).result)

DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/#{dbconfig[RACK_ENV]['database']}")

DataMapper.auto_upgrade!

Dir["#{File.dirname(__FILE__)}/../db/**/*.rb"].each { |f| require f }
