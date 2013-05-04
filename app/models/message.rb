class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MultiParameterAttributes
  
  field :active,  :type => Boolean,   :default => true
  field :body,    :type => String
  field :category,:type => String,    :default => 'dashboard'
  field :locked,  :type => Boolean,   :default => false
  field :title,   :type => String
  
  validates_presence_of     :body, :category, :title
  validates_inclusion_of    :category, :in => ['dashboard', 'customer', 'inventory']
  validates_inclusion_of    :locked, :in => [true, false]
  validates_inclusion_of    :active, :in => [true, false]
  
  default_scope ->{ where(:account_id => Account.current_id) }

  belongs_to  :account
  belongs_to  :user
  embeds_many :comments, cascade_callbacks: true
  
  accepts_nested_attributes_for :comments
end