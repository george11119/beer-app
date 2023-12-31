class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    return nil unless session[:user_id]

    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    return unless current_user.nil?

    redirect_to signin_path,
                notice: "you should be signed in"
  end
end
