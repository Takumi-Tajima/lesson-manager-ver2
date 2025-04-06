class Admins::UsersController < Admins::ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.default_order
  end

  def show
  end

  private

  def set_user
    @user = User.find(params.expect(:id))
  end
end
