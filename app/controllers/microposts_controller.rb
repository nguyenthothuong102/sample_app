class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t ".success"
      redirect_to root_path
    else
      @feed_items = current_user.microposts.paginate page: params[:page], per_page: Settings.size.s_10
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t".success"
      redirect_to request.referrer || root_path
    else
      flash[:danger] = t".danger"
      redirect_to root_path
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOST_TYPE
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost
    redirect_to root_path
  end
end
