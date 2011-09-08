class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :email, :type => String
  
  has_many :microposts
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
end
