class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def hired
    if current_omniauth_user
      sign_in_and_redirect current_omniauth_user
    else
      session["devise.hired_data"] = omniauth_provider_user_data
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def current_omniauth_user
    @_current_omniauth_user ||= begin
      User.find_or_create_by(provider: omniauth_provider_user_data.provider, uid: omniauth_provider_user_data.uid) do |new_user|
        new_user.email = omniauth_provider_user_data.info['email']
        new_user.name = omniauth_provider_user_data.info['name']
        new_user.password = Devise.friendly_token[0, 20]
      end
    end
  end

  def omniauth_provider_user_data
    @_omniauth_provider_user_data ||= request.env["omniauth.auth"]
  end
end
