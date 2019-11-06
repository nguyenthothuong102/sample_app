module follow
  def following
    @title = t "users.following"
    @users = @user.following.paginate page: params[:page], per_page: Settings.size.s_10
    render "show_follow"
  end

  def followers
    @title = t "users.followers"
    @users = @user.followers.paginate page: params[:page], per_page: Settings.size.s_10
    render "show_follow"
  end
end
