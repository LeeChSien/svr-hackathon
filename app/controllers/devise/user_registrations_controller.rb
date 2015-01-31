class Devise::UserRegistrationsController < Devise::RegistrationsController
  before_filter :set_ng_app

  before_filter :configure_permitted_parameters

  def set_ng_app
    super 'deviseApp'
  end

  protected
    # my custom fields are :name, :heard_how
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name, :email, :password, :password_confirmation)
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:name, :email, :password, :password_confirmation, :current_password)
      end
    end
end
