class UsersController < ApplicationController
  before_filter :authenticate_user!
  skip_before_action :authenticate_user!, only: [:new, :create, :confirm,
                     :password_reset_request, :password_update, :password_update_form]
  before_filter :owns_data!
  skip_before_action :owns_data!, only: [:new, :create, :confirm,
                     :password_reset_request, :password_update, :password_update_form]
  include SessionsHelper
  include ApplicationHelper

  def new
    unless current_user.nil?
      redirect_to :cameras_index
      return
    end
    @countries     = Country.all
    @share_request = nil
    if params[:key]
      @share_request = CameraShareRequest.where(status: CameraShareRequest::PENDING,
                                                key: params[:key]).first
    end
  end

  def create
    user = params[:user]
    begin
      if user.nil?
        raise "No user details specified in request."
      end
      output = get_evercam_api.create_user(user['forename'],
                                           user['lastname'],
                                           user['username'],
                                           user['email'],
                                           user['password'],
                                           params['country'],
                                           params[:share_request_key])

      user = User.where(email: user[:email].downcase).first
      sign_in user
      redirect_to "/"
    rescue => error
      env["airbrake.error_id"] = notify_airbrake(error)
      Rails.logger.error "Exception caught in create user request.\nCause: #{error}\n" +
                         error.backtrace.join("\n")
      flash[:message] = "An error occurred creating your account. Please try "\
                        "again and, if the problem persists, contact support."
      redirect_to action: 'new', user: user
    end
  end

  def confirm
    user = User.where(Sequel.expr(email: params[:u]) | Sequel.expr(username: params[:u])).first
    unless user.nil?
      code = Digest::SHA1.hexdigest(user.username + user.created_at.to_s)
      if params[:c] == code
        user.confirmed_at = Time.now
        user.save
        flash[:notice] = 'Successfully activated your account'
      else
        flash[:notice] = 'Activation code is incorrect'
      end
    end
    redirect_to '/signin'
  end

  def settings
    @countries = Country.all
  end

  def settings_update
    begin
      parameters = {}
      parameters[:forename] = params['user-forename'] if params.include?('user-forename')
      parameters[:lastname] = params['user-lastname'] if params.include?('user-lastname')
      parameters[:country]  = params['country'] if params.include?('country')
      if params.include?('email')
        parameters[:email] = params['email'] unless params['email'] = current_user.email
      end
      if !parameters.empty?
         get_evercam_api.update_user(current_user.username, parameters)
         session[:user] = User.by_login(current_user.username).email
         refresh_user
       end
      flash[:message] = 'Settings updated successfully'
    rescue => error
      env["airbrake.error_id"] = notify_airbrake(error)
      Rails.logger.error "Exception caught in update user request.\nCause: #{error}\n" +
                         error.backtrace.join("\n")
      flash[:message] = "An error occurred updating your details. Please try "\
                        "again and, if the problem persists, contact support."
    end
    redirect_to action: 'settings'
  end

  def password_reset_request
    email = params[:email]
    unless email.nil?
      user = User.by_login(email)

      if user
        t = Time.now
        if user.reset_token.present? and user.token_expires_at.present? and user.token_expires_at > t
          expires = user.token_expires_at
          token = user.reset_token
        else
          expires = t + 24.hour
          token = SecureRandom.hex(16)
        end

        user.update(reset_token: token, token_expires_at: expires)

        UserMailer.password_reset(email, user, token).deliver
        flash.now[:message] = "We’ve sent you an email with instructions for changing your password."
      else
        flash.now[:message] = "Email address not found."
      end
    end
  end

  def password_update_form
    username = params[:u]
    user = User.by_login(username)
    if user.nil? or user.token_expires_at.blank? or user.token_expires_at < Time.now
      @expired = true
    else
      @expired = false
    end
    render "password_update"
  end

  def password_update
    token = params[:token]
    username = params[:username]
    user = User.by_login(username)
    if user.nil? or token != user.reset_token or user.token_expires_at < Time.now
      flash[:message] = 'Invalid username or token'
    else
      user.update(reset_token: '', token_expires_at: Time.now)
      user.password = params[:password]
      user.save
      sign_in user
      redirect_to "/", message: 'Your password has been changed'
    end
  end

end
