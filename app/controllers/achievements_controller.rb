class AchievementsController < ApplicationController
  before_action :set_achievement, only: %i[ edit update ]

  def index
    @achievements = Current.user.achievements.default_order
  end

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

  def edit
  end

  def update
    if @achievement.update(achievement_params)
      redirect_to achievements_url, notice: "実績を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def achievement_params
    params.expect(achievement: %i[ name description memo parent_id achieved_on active ])
  end

  def set_achievement
    @achievement = Current.user.achievements.find(params[:id])
  end
end
