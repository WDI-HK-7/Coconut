class ProfilesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @profile = current_user.build_profile(profile_params)

    unless @profile.valid?
      return render :json => { message: @profile.errors.messages }
    end

    if @profile.save
      render :json => { message: "profile saved", profile: @profile, success: true }
    else
      render :json => { message: "profile not saved", success: false}
    end
  end

  def update
    @profile = current_user.profile

    if @profile.nil?
      create()
    else
      if @profile.update(profile_params)
        render :json => { message: "updated", sucess: true }
      else
        render :json => { message: "not updated", sucess: false }
      end
    end
  end

  def show
    @profile = User.find_by_id(params[:user_id]).profiles.first

    if @profile.nil?
      render :json => {
        message: "Can't find user profile"
      }
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:username, :first_name, :last_name, :content, :avatar)
  end

end
