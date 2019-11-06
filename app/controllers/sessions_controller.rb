class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == Settings.session.s_1 ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = t ".check_email"
        flash[:warning] = message
        redirect_to root_path
      end
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
