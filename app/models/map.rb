class Map
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :center,      :type => String
  field :identifier,  :type => String
  field :zoom,        :type => Integer, :default => 13
  
  validates_presence_of :center, :zoom
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  belongs_to  :account
end