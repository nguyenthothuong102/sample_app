class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: [:edit, :update]
  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".email_link"
      redirect_to root_path
    else
      flash.now[:danger] = t ".email_notfound"
      render :new
    end
  end

  def update
    @user.assign_attributes user_params
    if @user.update context: :reset_pass
      log_in @user
      @user.update_attributes :reset_digest, nil
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t ".danger_email"
    redirect_to login_path
  end

  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])
    redirect_to root_path
    flash[:danger] = t ".valid_user"
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".password_resets.danger_expired"
    redirect_to new_password_reset_path
  end
end
