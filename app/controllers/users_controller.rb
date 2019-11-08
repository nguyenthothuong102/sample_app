class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.actived.paginate page: params[:page]
  end

  def show
    @user = User.find_by id: params[:id]
    redirect_to root_path  && return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def destroy
    if @user.destroy?
    flash[:success] = t ".success"
    redirect_to users_path
    else
      render :new
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t (".please")
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def admin_user
    redirect_to root_path unless @user.admin?
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users.danger_login"
      redirect_to login_path
    end
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.danger_user"
    redirect_to root_path
  end

  def correct_user
    redirect_to @user unless current_user? @user
  end
end
