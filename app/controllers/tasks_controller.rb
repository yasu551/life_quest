class TasksController < ApplicationController
  before_action :set_task, only: %i[ edit update ]

  def index
    @tasks = Current.user.tasks.default_order
  end

  def new
    @task = Current.user.tasks.build
  end

  def create
    @task = Current.user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_url, notice: "タスクを作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスクを更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Current.user.tasks.find(params.expect(:id))
  end

  def task_params
    params.expect(task: %i[ name completion_condition status deadline_on sub_tasks memo ])
  end
end
