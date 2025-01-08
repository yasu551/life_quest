class Activities::BaseController < ApplicationController
  before_action :set_activity

  private

  def set_activity
    @activity = Current.user.activities.find(params.expect(:activity_id))
  end
end
