class Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  # GET /resource/password/new
  # def new
  #   super
  # end
  def create
    user = User.find_by(email: params[:body][:email])

    if user.blank?
      flash[:alert] = "Usuário não encontrado"
      redirect_to(new_user_password_path) and return
    end

    reset_password_token = Users::PasswordReseter.new(user).call

    if reset_password_token.present?
      # Password reset instructions sent successfully
      flash[:notice] = "Instruções para resetar senha enviadas para seu e-mail"
      render json: { success: true }
    else
      # Failed to send password reset instructions
      flash[:alert] = "Falha ao enviar instruções de resetar senha"
      render json: { success: false }
    end

    # redirect_to(new_user_password_path)
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    user = User.with_reset_password_token(params[:reset_password_token])
    if user.blank?
      flash[:error] = "O seu link de recuperação de senha expirou"
      redirect_to(new_user_password_path)
      return
    end
    super
    # render json: { success: true, user:user }
  end

  # POST /resource/password
  # def create
  #   user = User.find_by(email: params[:password][:body][:email])
  #   if user.present?
  #     Users::PasswordReseter.new(user).call
  #     flash[:notice] = "Instruções para resetar senha enviadas para seu e-mail"
  #     redirect_to 'http://localhost:3001/recuperar_senha', allow_other_host: true and return
  #   else
  #     flash[:alert] = "Usuário não encontrado. Verifique se digitou o e-mail corretamente"
  #     redirect_to 'http://localhost:3001/recuperar_senha', allow_other_host: true and return
  #   end
  # end

  # # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   user = User.with_reset_password_token(params[:reset_password_token])
  #   if user.blank?
  #     flash[:error] = t(".link_expired")
  #     redirect_to 'http://localhost:3001/recuperar_senha', allow_other_host: true
  #     return
  #   end
  #   super
  # end

  # PUT /resource/password
  def update

    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      # Password updated successfully
      # sign_in(resource_name, resource)
      render json: { success: true, user: resource }
    else
      # Password update failed
      render json: { success: false }
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
