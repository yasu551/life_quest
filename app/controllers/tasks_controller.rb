class TasksController < ApplicationController
  active_menu :task
  before_action :set_task, only: %i[ edit update destroy ]
  before_action :set_tags, only: %i[ new create edit update ]

  def index
    @tags = Current.user.tags.default_order
    respond_to do |format|
      format.turbo_stream do
        @status = params[:status]
        if turbo_frame_request? && @status.present?
          @tasks = Current.user.tasks.with_status(@status).includes(:tags).page(params[:page])
          if @status == "completed"
            @tasks = @tasks.latest_completed
          else
            @tasks = @tasks.default_order
          end
          if params[:tag_id].present?
            tag = Current.user.tags.find(params[:tag_id])
            @tasks = @tasks.tagged_with(tag)
          end
          if params[:perform_on].present?
            @tasks = @tasks.scheduled_on(params[:perform_on])
          end
          if params[:completed_on].present?
            @tasks = @tasks.completed_on(params[:completed_on])
          end
        end
      end
      format.html
    end
  end

  def new
    @task = Current.user.tasks.build
  end

  def create
    @task = Current.user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_url(format: :html), notice: "タスクを作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    updated =
      if params[:time_entries].present?
        @task.update_and_create_time_entries(task_params)
      elsif params[:sub_tasks].present?
        @task.update_with_generated_sub_tasks(task_params)
      else
        @task.update(task_params)
      end
    if updated
      url = @task.status.completed? ? tasks_url(format: :html) : edit_task_url(@task)
      redirect_to url, notice: "タスクを更新しました。"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @task.destroy!
    redirect_to tasks_url(format: :html), notice: "タスクを削除しました。", status: :see_other
  end

  private

  def set_task
    @task = Current.user.tasks.find(params.expect(:id))
  end

  def set_tags
    @tags = Current.user.tags.default_order
  end

  def task_params
    params.expect(task: [ :name, :completion_condition, :status,
                         :deadline_on, :perform_on, :completed_on, :sub_tasks, :memo,
                         :estimated_pomodoro_count,
                         tag_ids: [] ])
  end
end
