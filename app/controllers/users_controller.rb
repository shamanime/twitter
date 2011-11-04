class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @users = User.page(params[:page]).per(15)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page params[:page]
    @title = @user.name
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def edit
    @title = "Edit user"
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success =>  'Welcome to the Twister App!' }
    else
      @title = "Sign up"
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, :flash => { :success =>  'Profile updated.' }
    else
      @title = "Edit user"
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      redirect_to users_path, :flash => { :error =>  'Do not delete yourself!' }
    else
      @user.destroy
      redirect_to users_path, :flash => { :success =>  'User destroyed.' }
    end
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following_user_list.page params[:page]
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers_user_list.page params[:page]
    render 'show_follow'
  end
  
  def follow
    @user = User.find(params[:id])
    current_user.follow!(@user)
    redirect_to @user
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow!(@user)
    redirect_to @user
  end
  
  private  
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
