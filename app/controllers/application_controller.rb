class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :require_authentication
  helper_method :signed_in?, :current_user

  def self.allow_unauthenticated_access(**actions)
    skip_before_action :require_authentication, **actions
  end

  private
    def signed_in?
      current_user
    end

    def current_user
      @current_user = User.find_by(id: session[:current_user_id]) if session[:current_user_id]
    end

    def request_sign_in
      session[:previous_url] = request.url
      redirect_to sign_in_path
    end

    def request_password_reset
      return true if [ expired_password_path, update_expired_password_path ].include? request.path

      session[:previous_url] = request.url
      redirect_to expired_password_path
    end

    def has_valid_password
      !@current_user.expired_password? || request_password_reset
    end

    def require_authentication
      (current_user && has_valid_password) || request_sign_in
    end

    def after_sign_in_url
      session.delete(:previous_url) || root_url
    end

    def new_session(user)
      session[:current_user_id] = user.id
    end

    def sign_out
      session.delete(:current_user_id)
    end
end
