class Image
  include Mongoid::Document
  include Mongoid::Paperclip
  
  field :name,        :type => String
  field :description, :type => String
  
  attr_accessor :image_url
  
  has_mongoid_attached_file :image,
    :default_url => '/assets/missing/:attachment/missing_:style.png'
  
  embedded_in :album
  
  def image_url=(url)
    unless url.to_s.empty?
      self.image = URI.parse(url)
    end
  end
  
  def image_url
    nil
  end
end