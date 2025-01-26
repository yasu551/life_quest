class ScheduledActivitiesController < ApplicationController
  def new
    @scheduled_activity_form = ScheduledActivityForm.new
  end

  def create
    @scheduled_activity_form = ScheduledActivityForm.new(scheduled_activity_params)
    if @scheduled_activity_form.save
      redirect_to activities_url(scope_chains: "scheduled"), notice: "実行予定の行動を作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def scheduled_activity_params
    params.expect(scheduled_activity: %i[ name start_on end_on time schedule_type weekday day memo ])
          .merge(user_id: Current.user.id)
  end
end
