class NotificationsController < ApplicationController
  active_menu :notification

  def index
    @notifications = Current.user.notifications.page(params[:page]).default_order
  end
end
