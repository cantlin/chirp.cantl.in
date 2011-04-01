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
    @current_user = current_user
    redirect_to login_path unless (@current_user && @current_user.save)
  end

end
