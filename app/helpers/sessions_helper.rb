module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
  end

  def sign_out
    cookies.delete :remember_token
    cookies.delete 'dismissed_system-message.welcome' # hack
    reset_session
  end

  def signed_in?
    !cookies.signed[:remember_token].blank?
  end

  def current_user
    @current_user ||= User.from_cookie(*cookies.signed[:remember_token]) if cookies.signed[:remember_token]
  end

  def authenticate
    unless current_user
      sign_out if signed_in?
      redirect_to login_path
    end
  end

  def update_last_login
    @current_user.save if @current_user
  end

end
