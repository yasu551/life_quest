class ActivitiesController < ApplicationController
  active_menu :activity
  before_action :set_activity, only: %i[ edit update destroy ]
  before_action :set_tasks, only: %i[ new create edit update ]

  def index
    @activities = Current.user.activities.page(params[:page]).default_order
    scope_chains = params&.dig(:scope_chains)
    if scope_chains.present?
      @activities = @activities.applied_scopes(scope_chains)
    end
  end

  def new
    @activity = Current.user.activities.build
    @activity.build_activity_evaluation
  end

  def create
    @activity = Current.user.activities.build(activity_params)
    if @activity.save
      redirect_to activities_url, notice: "行動を作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @activity.update(activity_params)
      redirect_to edit_activity_url(@activity), notice: "行動を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy!
    redirect_to activities_url, notice: "行動を削除しました。", status: :see_other
  end

  private

  def set_activity
    @activity = Current.user.activities.find(params.expect(:id))
  end

  def set_tasks
    @tasks = Current.user.tasks.default_order
  end

  def activity_params
    params.expect(activity: [ :name, :task_id, :perform_at, :performed_at, :memo, activity_evaluation_attributes: %i[ value reason ] ])
  end
end
