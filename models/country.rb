class Country
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :flagSrc, String
  property :url, String
end
