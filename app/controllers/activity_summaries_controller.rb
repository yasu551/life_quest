class ActivitySummariesController < ApplicationController
  before_action :set_activity_summary, only: %i[ edit update destroy ]
  before_action :set_activities, only: %i[ new create edit update ]

  def index
    @activity_summaries = Current.user.activity_summaries.default_order
  end

  def new
    @activity_summary = Current.user.activity_summaries.build
  end

  def create
    @activity_summary = Current.user.activity_summaries.build(activity_summary_params)
    if @activity_summary.save
      redirect_to activity_summaries_url, notice: "行動サマリを作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @activity_summary.update(activity_summary_params)
      redirect_to activity_summaries_url, notice: "行動サマリを更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity_summary.destroy!
    redirect_to activity_summaries_url, notice: "行動サマリを削除しました。", status: :see_other
  end

  private

  def set_activity_summary
    @activity_summary = Current.user.activity_summaries.find(params.expect(:id))
  end

  def set_activities
    @activities = Current.user.activities.default_order
  end

  def activity_summary_params
    params.expect(activity_summary: [:start_on, :end_on, :content, :memo, activity_ids: []])
  end
end
