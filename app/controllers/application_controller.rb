class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :require_authentication
  helper_method :signed_in?

  def self.allow_unauthenticated_access(**actions)
    skip_before_action :require_authentication, **actions
  end

  private
    def signed_in?
      find_session_by_cookie
    end

    def require_authentication
      find_session_by_cookie || request_sign_in
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_sign_in
      cookies[:previous_url] = request.url
      redirect_to sign_in_path
    end

    def after_sign_in_url
      cookies.delete(:previous_url) || root_url
    end

    def new_session(user)
      session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
      cookies.signed[:session_id] = { value: session.id, expires: 30.minutes, httponly: :only }
    end

    def sign_out
      find_session_by_cookie&.destroy
      cookies.delete(:session_id)
    end
end
