# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  prepend_before_action :authenticate_scope! , only: [:edit, :edit_password, :update, :update_password, :destroy]
  prepend_before_action :set_minimum_password_length, only: [:new, :edit, :edit_password]
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    build_resource
    yield resource if block_given?
    respond_with resource
  end

    # GET /resource/before_sign_up
  def before_create
    @user =  User.find(params["resource"])
    @token = params["confirmation_token"]
  end
    # PUT /resource/before_sign_up
  def before_update
    @user = User.find(params["user"]["user_id"])
    @user.name = params["user"]["name"]
    @user.save
    @token = params["confirmation_token"]

    binding.pry

    redirect_to confirmation_path(resource, confirmation_token: @token)
  end

  # POST /resource
  def create
    build_resource(sign_up_params)
    # temporary session data to the newly created user.
    # build_resourceメソッドの中身
    # def build_resource(hash = {})
    #   self.resource = resource_class.new_with_session(hash, session)
    # end
    resource.save
    yield resource if block_given?
    if resource.persisted?
    #保存されているかどうかの確認
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
