module UsersHelper
  def gravatar_for(user, options = { :size => 50 })
    image_tag user.gravatar_url(options), :class => "gravatar", :alt => user.name
  end
end
