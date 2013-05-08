class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  
  field :content,   :type => String
  field :published, :type => Boolean, :default => false
  field :summary,   :type => String
  field :title,     :type => String
  
  attr_accessor :image_url, :image_delete
  
  before_validation { image.clear if image_delete == '1' }
  
  has_mongoid_attached_file :image,
    :default_url => '/assets/missing/:attachment/missing_:style.png'
    
  validates_presence_of     :title, :summary, :content
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  belongs_to  :account
  
  def image_url=(url)
    unless url.to_s.empty?
      self.image = URI.parse(url)
    end
  end
  
  def image_url
    nil
  end
end