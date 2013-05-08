class Link
  include Mongoid::Document
  include Mongoid::Paperclip
  
  field :name,          :type => String
  field :description,   :type => String
  field :index,         :type => Integer, :default => 0
  field :url,           :type => String
  
  attr_accessor :image_url
  
  has_mongoid_attached_file :image,
    :default_url => '/assets/missing/:attachment/missing_:style.png'
  
  validates_presence_of     :name, :url
  
  embedded_in :nav
  
  def image_url=(url)
    unless url.to_s.empty?
      self.image = URI.parse(url)
    end
  end
  
  def image_url
    nil
  end
end