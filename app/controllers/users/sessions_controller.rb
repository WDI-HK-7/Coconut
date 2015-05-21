class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "users/sessions#failure")
    return sign_in_and_redirect(resource_name, resource)
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    return render json: {:success => true, :message => "success"}, status: 200
  end

  def failure
    return render json: {:success => false, :message => "failed"}, status: 400
  end

  def destroy
    signed_out = sign_out(resource_name)
    render json: {:success => true, :message => "logged out"}
  end

  def authenticated
    if current_user.nil?
      return render json: {:signed_in => false}
    else
      return render json: 
        {
          :signed_in => true,
          :current_user_id => current_user.id
      }
    end
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
