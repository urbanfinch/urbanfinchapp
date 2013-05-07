class Bullet
  include Mongoid::Document
  
  field :title,         :type => String
  field :content,       :type => String
  field :index,         :type => Integer, :default => 0
  
  validates_presence_of :content, :index
  
  embedded_in :list
end