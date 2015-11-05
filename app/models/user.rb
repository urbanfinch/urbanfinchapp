require_dependency 'email_validator'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :active, :type => Boolean,        :default => true
  field :administrator, :type => Boolean, :default => false
  field :auth_token, :type => String,     :default => ->{ generate_token(:auth_token) }
  field :email, :type => String
  field :first_name, :type => String
  field :last_name, :type => String
  field :locked, :type => Boolean,        :default => false
  field :password_hash, :type => String
  field :password_salt, :type => String
  field :reset_token, :type => String,    :default => ->{ generate_token(:reset_token) }
  field :reset_time, :type => Time,       :default => -> { Time.now }
  field :username, :type => String

  attr_accessor :avatar_url
  attr_accessor :password

  has_mongoid_attached_file :avatar,
    :default_url => '/missing/users/:attachment/missing_:style.png',
    :styles => {
      :small        => ['48x48#',   :png],
      :tiny         => ['18x18#',   :png]
    }

  validates_inclusion_of    :active, :in => [true, false]
  validates_inclusion_of    :administrator, :in => [true, false]
  validates_uniqueness_of   :auth_token
  validates_presence_of     :email
  validates_uniqueness_of   :email, scope: :account_id
  validates                 :email, :email => true
  validates_presence_of     :first_name
  validates_presence_of     :last_name
  validates_inclusion_of    :locked, :in => [true, false]
  validates_presence_of     :password, :on => :create
  validates_confirmation_of :password
  validates_presence_of     :username
  validates_uniqueness_of   :username, scope: :account_id

  default_scope ->{ where(:account_id => Account.current_id) }

  before_save     :_encrypt_password

  belongs_to      :account
  has_many        :activities

  def self.authenticate(username_or_email, password)
    user = where('$or' => [{"username" => username_or_email}, {"email" => username_or_email}], :active => true, :locked => false).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.where(column => self[column]).exists?
  end

  def send_reset
    generate_token(:reset_token)
    self.reset_time = Time.now
    save!
    Authentication::ResetMailer.reset(self).deliver
  end

  def fullname
    "#{self.first_name} #{self.last_name}"
  end

  def avatar_url=(url)
    unless url.to_s.empty?
      self.avatar = URI.parse(url)
    end
  end

  def avatar_url
    nil
  end

  private

  def _encrypt_password
    if self.password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(self.password, self.password_salt)
    end
  end
end
