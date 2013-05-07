class Property
  include Mongoid::Document
  
  field :key,   :type => String
  field :value, :type => String
  
  validates_presence_of :key, :value
  
  embedded_in :account
end