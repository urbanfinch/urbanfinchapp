class Album
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  
  field :name,                :type => String
  field :identifier,          :type => String
  field :index,               :type => Integer, :default => 0
  field :description,         :type => String
  
  attr_accessor :image_url
  
  has_mongoid_attached_file :image,
    :default_url => '/assets/missing/:attachment/missing_:style.png'
  
  validates_presence_of :name
  
  default_scope ->{ where(:account_id => Account.current_id) }
  
  belongs_to  :account
  embeds_many :images, cascade_callbacks: true
  
  accepts_nested_attributes_for :images
  
  def image_url=(url)
    unless url.to_s.empty?
      self.image = URI.parse(url)
    end
  end
  
  def image_url
    nil
  end
end