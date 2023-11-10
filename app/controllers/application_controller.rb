class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :auth_request?
	skip_before_action :verify_authenticity_token
  # before_action :configure_permitted_parameters, if: :devise_controller?

	private

	def auth_request?
		params[:controller].include?("devise_token_auth") &&
			((controller_name == "sessions" && action_name == "create") ||
			(controller_name == "registrations" && action_name == "create"))
	end

  # def configure_permitted_parameters
  #   # For additional fields in app/views/devise/registrations/new.html.erb
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :document_number])

  #   # For additional in app/views/devise/registrations/edit.html.erb
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:full_name, :document_number, :address_street, :address_number, :address_complement, :address_neighborhood, :address_postal_code, :state_id, :city_id, :photo])
  # end
end
