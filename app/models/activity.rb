class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :action, :type => String
  
  validates_presence_of :action
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  belongs_to :account
  belongs_to :trackable, :polymorphic => true
  belongs_to :user
end