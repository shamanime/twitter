class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  # POST /microposts
  # POST /microposts.json
  def create
    @micropost  = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  # DELETE /microposts/1
  # DELETE /microposts/1.json
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost destroyed."
    redirect_back_or root_path
  end

  private
    def authorized_user
      @micropost = current_user.microposts.find(params[:id])
      rescue
        redirect_to root_path
    end
end
