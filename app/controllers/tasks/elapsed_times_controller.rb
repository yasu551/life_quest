class Tasks::ElapsedTimesController < Tasks::BaseController
  def update
    @task.update!(task_params)
    head :ok
  end

  private

  def task_params
    params.expect(task: %i[elapsed_time])
  end
end
