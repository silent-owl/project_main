class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :banned
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  
  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Art Spaces!"
      redirect_to @user
      # Handle a successful save.
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  def delete_users
    if params[:user_check]
      User.where(id: params[:user_check]).destroy_all
    end 
    redirect_to users_url
  end

  def ban_users
    if params[:user_check]
      User.where(id: params[:user_check]).update_all(ban:true)
    end  
    redirect_to users_url
  end

  def unban_users
    if params[:user_check]
      User.where(id: params[:user_check]).update_all(ban:false)
    end
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

     # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end


  protected
    def banned
      if current_user.present? && current_user.ban?
        redirect_to root_url
        flash[:danger] = "You are banned on this site!"
      end 
    end  
end
