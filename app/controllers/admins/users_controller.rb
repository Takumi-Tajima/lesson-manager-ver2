class Admins::UsersController < Admins::ApplicationController
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.default_order
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admins_user_path(@user), notice: t('controllers.common.updated', model: 'ユーザー'), status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params.expect(:id))
  end

  def user_params
    params.expect(user: %i[name email password password_confirmation])
  end
end
