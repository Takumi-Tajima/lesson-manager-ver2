class Users::PastReservationsController < Users::ApplicationController
  def index
    @reservations = current_user.reservations.past.order_by_start
  end
end
