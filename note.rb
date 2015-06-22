require 'data_mapper'

class Note
  include DataMapper::Resource

  property :id, Serial
  property :text, String
end

