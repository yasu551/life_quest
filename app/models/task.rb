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
end
