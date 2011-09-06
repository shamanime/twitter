class Micropost
  include Mongoid::Document
  
  field :content, :type => String
  
  belongs_to :user
  validates :content, :length => { :maximum => 140 }
end
