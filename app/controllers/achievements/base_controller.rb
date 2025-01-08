class Achievements::BaseController < ApplicationController
  before_action :set_achievement

  private

  def set_achievement
    @achievement = Current.user.achievements.find(params.expect(:achievement_id))
  end
end
