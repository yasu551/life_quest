class AchievementsController < ApplicationController
  before_action :set_achievement, only: %i[ edit update destroy ]
  before_action :set_achievements, only: %i[ index new create edit update]

  def index
    scope_chains = params&.dig(:scope_chains)
    if scope_chains.present?
      @achievements = @achievements.applied_scopes(scope_chains)
    end
  end

  def new
    @achievement = Current.user.achievements.build
  end

  def create
    @achievement = Current.user.achievements.build(achievement_params)
    if @achievement.save
      redirect_to achievements_url, notice: "実績を作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @achievement.update(achievement_params)
      redirect_to achievements_url, notice: "実績を更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @achievement.destroy!
    redirect_to achievements_url, notice: "実績を削除しました。", status: :see_other
  end

  private

  def achievement_params
    params.expect(achievement: %i[ name description memo parent_id achieved_on active ])
  end

  def set_achievement
    @achievement = Current.user.achievements.find(params.expect(:id))
  end

  def set_achievements
    @achievements = Current.user.achievements.default_order
  end
end
