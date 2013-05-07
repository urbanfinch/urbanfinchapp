class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
    
  field :name,    :type => String
  field :email,   :type => String
  field :phone,   :type => String
  field :message, :type => String
  
  validates_presence_of     :name
  validates_presence_of     :email
  validates                 :email, :email => true
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  belongs_to  :account
end