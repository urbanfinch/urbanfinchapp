class Account
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :active,      :type => Boolean,   :default => true
  field :api_active,  :type => Boolean,   :default => false
  field :api_secret,  :type => String,    :default => ->{ UUID.generate(:compact) }
  field :locked,      :type => Boolean,   :default => false
  field :title,       :type => String
  field :token,       :type => String,    :default => ->{ UUID.generate(:compact) }

  validates_presence_of     :token, :api_secret
  validates_inclusion_of    :locked, :in => [true, false]
  validates_inclusion_of    :active, :in => [true, false]
  validates_uniqueness_of   :token
  validates_format_of       :token, :with => /\A[a-z0-9_]+\z/, 
                                    :message => "must contain only lowercase letters, numbers and underscores."
  validates_length_of       :api_secret,  :is => 32
  
  default_scope ->{ where(:active => true, :locked => false) }

  has_many :activities, :dependent => :destroy
  has_many :messages,   :dependent => :destroy
  has_many :users,      :dependent => :destroy
  
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
  
  def prune!
    self.associations.keys.each do |relation|
      self.send(relation.to_s).each do |record|
        record.destroy unless record.active
      end
    end
    self.save
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