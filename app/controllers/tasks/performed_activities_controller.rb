class Tasks::PerformedActivitiesController < Tasks::BaseController
  def new
  end

  def create
    date = performed_activities_params[:performed_on].to_date
    @task.create_performed_activities!(date:)
    redirect_to edit_task_url(@task), notice: "分報から行動を作成しました。", status: :see_other
  end

  private

  def performed_activities_params
    params.expect(performed_activities: %i[ performed_on ])
  end
end
