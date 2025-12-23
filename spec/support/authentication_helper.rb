module AuthenticationHelpers
  def stub_authentication_for(user)
    allow_any_instance_of(ApplicationController).to receive(:require_authentication).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user) do |controller|
      controller.instance_variable_set(:@current_user, user)
      user
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
  config.include AuthenticationHelpers, type: :controller
end
