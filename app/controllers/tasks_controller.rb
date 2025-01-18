class TasksController < ApplicationController
  active_menu :task
  before_action :set_task, only: %i[ edit update destroy ]
  before_action :set_tags, only: %i[ new create edit update ]

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
      redirect_to edit_task_url(@task), notice: "タスクを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!
    redirect_to tasks_url, notice: "タスクを削除しました。", status: :see_other
  end

  private

  def set_task
    @task = Current.user.tasks.find(params.expect(:id))
  end

  def set_tags
    @tags = Current.user.tags.default_order
  end

  def task_params
    params.expect(task: [:name, :completion_condition, :status, :deadline_on, :sub_tasks, :memo, tag_ids: []])
  end
end
