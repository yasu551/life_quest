class AchievementsController < ApplicationController
  active_menu :achievement
  before_action :set_achievement, only: %i[ edit update destroy ]
  before_action :set_achievements, only: %i[ index new create edit update]

  def index
    @achievements = @achievements.page(params[:page]).default_order
    scope_chains = params&.dig(:scope_chains)
    if scope_chains.present?
      @achievements = @achievements.applied_scopes(scope_chains)
    end
  end

  def new
    parent_achievement_id = params[:parent_achievement_id]
    child_achievement_id = params[:child_achievement_id]
    if parent_achievement_id.present?
      parent_achievement = @achievements.find(parent_achievement_id)
      @achievement = parent_achievement.build_child
    elsif child_achievement_id.present?
      child_achievement = @achievements.find(child_achievement_id)
      @achievement = child_achievement.build_intermediate
    else
      @achievement = @achievements.build
    end
  rescue StandardError => e
    redirect_to request.referer, alert: e.message, status: :see_other
  end

  def create
    @achievement = Current.user.achievements.build(achievement_params)
    if @achievement.save
      redirect_to achievements_url, notice: "実績を作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @achievement.update(achievement_params)
      redirect_to edit_achievement_url(@achievement), notice: "実績を更新しました。"
    else
      render :edit, status: :unprocessable_content
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
