class AchievementsController < ApplicationController
  def new
    @achievement = Current.user.achievements.build
  end

  def create
    @achievement = Current.user.achievements.build(achievement_params)
    if @achievement.save
      redirect_to achievements_url, notice: "実績を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def achievement_params
    params.expect(achievement: %i[ name description memo parent_id achieved_on active ])
  end
end
