class Micropost
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content, :type => String
  
  attr_accessible :content
  
  belongs_to :user
  validates :content,
            :presence => true,
            :length => { :maximum => 140 }
            
  default_scope desc(:created_at)
  
  def self.from_users_followed_by(user)
    user_ids = user.following
    user_ids << user.id
    any_in(user_id: user_ids)
  end
end
