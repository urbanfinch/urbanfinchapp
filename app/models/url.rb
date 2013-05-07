class Url
  include Mongoid::Document
  
  field :name,  :type => String
  field :url,   :type => String
  
  validates_presence_of :name, :url
  
  embedded_in :employee
end