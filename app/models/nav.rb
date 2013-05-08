class Nav
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :description,   :type => String
  field :identifier,    :type => String
  field :name,          :type => String
  
  validates_presence_of     :name
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  belongs_to  :account
  embeds_many :links, cascade_callbacks: true
  
  accepts_nested_attributes_for :links, :allow_destroy => true
end