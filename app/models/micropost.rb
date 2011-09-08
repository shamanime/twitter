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
end
