class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :api_active,  :type => Boolean,   :default => false
  field :api_secret,  :type => String,    :default => ->{ UUID.generate(:compact) }
  field :title,       :type => String
  field :token,       :type => String,    :default => ->{ UUID.generate(:compact) }

  validates_presence_of     :token, :api_secret
  validates_uniqueness_of   :token
  validates_format_of       :token, :with => /\A[a-z0-9_]+\z/,
                                    :message => "must contain only lowercase letters, numbers and underscores."
  validates_length_of       :api_secret,  :is => 32

  has_many :activities,   :dependent => :destroy
  has_many :albums,       :dependent => :destroy
  has_many :blurbs,       :dependent => :destroy
  has_many :contacts,     :dependent => :destroy
  has_many :employees,    :dependent => :destroy
  has_many :lists,        :dependent => :destroy
  has_many :maps,         :dependent => :destroy
  has_many :navs,         :dependent => :destroy
  has_many :posts,        :dependent => :destroy
  has_many :testimonials, :dependent => :destroy
  has_many :users,        :dependent => :destroy

  embeds_many :properties

  accepts_nested_attributes_for :properties, :allow_destroy => true

  def self.current_id=(id)
    Thread.current[:current_id] = id
  end

  def self.current_id
    Thread.current[:current_id]
  end

  def set_current
    self.class.current_id = self.id
  end

  def records
    count = 0
    self.associations.keys.each do |relation|
      count += self.send(relation.to_s).count
    end
    return count
  end

  def reset!
    self.associations.keys.each do |relation|
      self.send(relation.to_s).destroy_all
    end
    self.save
  end

  def regenerate_api_secret
    self.api_secret = UUID.generate(:compact)
  end
end
