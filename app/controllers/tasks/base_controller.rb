class Tasks::BaseController < ApplicationController
  before_action :set_task

  private

  def set_task
    @task = Current.user.tasks.find(params.expect(:task_id))
  end
end
