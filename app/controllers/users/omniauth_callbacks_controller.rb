class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :logout

  def twitter
    if current_user
      current_user.fee = params[:fee]
      current_user.save
    end
    session[:fee] = params[:fee]
    @user = User::TwitterExtension.oauth_twitter_provider(request.env["omniauth.auth"], current_user)
    proceed_oauth("Twitter", request.env["omniauth.auth"].except("extra"))

    # if @user.persisted?
    #   flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Twitter"
    #   sign_in_and_redirect @user, event: :authentication
    # else
    #   session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
    #   redirect_to new_user_registration_url
    # end
  end

  private

  def logout
    session[:user] = nil
  end

  def clean_public_token
    @public_token = session[:public_token]
    session[:public_token] = nil
  end

  def proceed_oauth(kind, req)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind

      clean_public_token

      if @public_token.blank?
        sign_in_and_redirect @user, event: :authentication
      else
        request.env['omniauth.origin'] = activate_link_url(@public_token)
        sign_in_and_redirect @user, event: :authentication
      end
    else
      session["devise."+ kind.downcase + "_data"] = req
      redirect_to new_user_registration_url
    end
  end
end






