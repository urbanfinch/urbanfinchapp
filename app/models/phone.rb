class Phone
  include Mongoid::Document
    
  field :type,    :type => String
  field :number,  :type => String
  
  validates_presence_of     :type, :number
  
  embedded_in :employee
end