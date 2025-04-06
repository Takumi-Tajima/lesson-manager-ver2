class Admins::UsersController < Admins::ApplicationController
  def index
    @users = User.default_order
  end
end
