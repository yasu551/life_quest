class Tasks::TimeEntriesController < Tasks::BaseController
  before_action :set_time_entry, only: %i[ edit update destroy ]

  def index
    @time_entry = @task.time_entries.build
    @time_entries = @task.time_entries.page(params[:page]).default_order
  end

  def create
    @time_entry = @task.time_entries.build(time_entry_params)
    if @time_entry.save
      redirect_to task_time_entries_url(@task), notice: "分報を作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @time_entry.update(time_entry_params)
      redirect_to task_time_entries_url(@task), notice: "分報を更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @time_entry.destroy!
    redirect_to task_time_entries_url(@task), notice: "分報を削除しました。", status: :see_other
  end

  private

  def time_entry_params
    params.expect(time_entry: %i[ content ])
  end

  def set_time_entry
    @time_entry = @task.time_entries.find(params.expect(:id))
  end
end
