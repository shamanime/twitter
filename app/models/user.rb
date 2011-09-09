require 'digest'
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Gravtastic
  include Gravtastic
  is_gravtastic
  
  field :name, :type => String
  field :email, :type => String
  index :email, unique: true
  field :encrypted_password, :type => String
  field :salt, :type => String
  field :admin, :type => Boolean, :default => false
  
  field :following, :type => Array, :default => []
  index :following
  
  has_many :microposts, :dependent => :destroy
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true, :on => :create,
                       :confirmation => true, :on => :create,
                       :length       => { :within => 6..40 }

  def has_password?(submitted_password)
   encrypted_password == encrypt(submitted_password)
  end
  
  #def self.authenticate(email, submitted_password)
  #  user = find_by_email(email)
  #  return nil  if user.nil?
  #  return user if user.has_password?(submitted_password)
  #end
  def self.authenticate(email, submitted_password)
    user = User.where(email: email).first
    user && user.has_password?(submitted_password) ? user : nil
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = id.present? ? User.find(id) : nil
    (user && user.salt == cookie_salt) ? user : nil
  end
                  
  before_save :encrypt_password
  
  def feed
    microposts
  end
  
#######################################################################################################
  def following_count
    following.count
  end

  def followers_count
    followers_user_list.count
  end
  
  def followers
    followers = []
    User.where(:following => self.id).each do |user|
      followers << user.id
    end
    followers
  end
  
  def following?(followed)
    User.where(:_id => self.id, :following => followed.id).count > 0
  end
  
  def follow!(obj)
    send :following=, [] if (following.nil?)
    following << obj.id unless following.include?(obj.id)
    save :validation => false
  end
  
  def unfollow!(obj)
    send :following=, [] if (following.nil?)
    following.delete(obj.id) if following.include?(obj.id)
    save :validation => false
  end
  
  def followers_user_list
    User.where(:following => self.id)
  end
  
  def following_user_list
    User.any_in(:_id => following)
  end
#######################################################################################################
  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end