class Comment
  include Mongoid::Document
  
  field :body,    :type => String
  field :date,    :type => DateTime,  :default => ->{ Time.now }
  
  validates_presence_of     :body, :date
  
  belongs_to  :user
  embedded_in :message
end