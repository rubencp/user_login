class AuthenticationController < ApplicationController

  def iniciar_sesion
    @user = User.new
  end
  
  def log_in
    username_or_email = params[:user][:name]
    password = params[:user][:password]

    if username_or_email.rindex('@')
      email=username_or_email
      user = User.authenticate_by_email(email, password)
    else
      username=username_or_email
      user = User.authenticate_by_name(username, password)
    end

    if user
     session[:user_id] = user.id
     flash[:notice] = "Hola " + user.name
     redirect_to :root
    else
     flash.now[:error] = 'Unknown user. Please check your username and password.'
     
     @user = User.new
     render :action => "iniciar_sesion"
    end

  end

def cerrar_sesion
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."
end

def nuevo_usuario
  @user = User.new(params[:user])

  if @user.valid?
    @user.save
    session[:user_id] = @user.id
    flash[:notice] = 'Welcome.'
    redirect_to :root
  else
    render :action => "nuevo_usuario"
  end
end

end