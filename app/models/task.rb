class Task < ApplicationRecord
  extend Enumerize

  paginates_per 10

  enumerize :status, in: %i[new waiting working completed pending], scope: true

  belongs_to :user
  has_many :time_entries, dependent: :restrict_with_exception
  has_many :activities, dependent: :restrict_with_exception
  has_many :task_taggings, dependent: :destroy
  has_many :tags, through: :task_taggings

  validates :name, presence: true
  validates :deadline_on, date: { allow_blank: true }
  validates :perform_on, date: { allow_blank: true }

  scope :default_order, -> { order(Arel.sql("deadline_on ASC NULLS LAST, perform_on ASC NULLS LAST, id DESC")) }
  scope :scheduled_on, ->(date) { where(perform_on: date) }
  scope :tagged_with, ->(tag) { where(id: TaskTagging.where(tag:).select(:task_id)) }

  def destroyable?
    !time_entries.exists? && !activities.exists?
  end

  def update_with_generated_sub_tasks(params)
    self.attributes = params
    self.sub_tasks = generate_sub_tasks
    save
  end

  def update_and_create_time_entries(params)
    transaction do
      update(params)
      if saved_change_to_sub_tasks?
        create_time_entries_from_sub_tasks_difference
      end
    end
  end

  private

  def generate_sub_tasks
    message_content = <<~CONTENT
      以下の情報をもとに、サブタスクを出力してください。

      Input:
      タスク名: #{name}
      完了条件:
      #{completion_condition}
    CONTENT
    yml = YAML.load_file(Rails.root.join("app/models/task/generate_sub_tasks_prompt.yml")).deep_symbolize_keys
    messages = yml[:messages]
    messages << { role: :user, content: message_content }
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-4o",
        messages:
      }
    )
    response.dig("choices", 0, "message", "content")
  end

  def create_time_entries_from_sub_tasks_difference
    message_content = <<~CONTENT
      以下の情報をもとに、サブタスクの差分から分報を出力してください。

      Input:
      - 1つ前のサブタスク:
        #{sub_tasks_before_last_save}
      - 現在のサブタスク:
        #{sub_tasks}
    CONTENT
    yml = YAML.load_file(Rails.root.join("app/models/task/create_time_entries_from_sub_tasks_difference_prompt.yml")).deep_symbolize_keys
    messages = yml[:messages]
    messages << { role: :user, content: message_content }
    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-4o",
        messages:
      }
    )
    content = response.dig("choices", 0, "message", "content")
    time_entry_contents = JSON.parse(content)
    transaction do
      time_entry_contents.each do |content|
        time_entries.create!(content:)
      end
    end
  end
end
