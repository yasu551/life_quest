class Achievement < ApplicationRecord
  APPLICABLE_SCOPE_NAMES = %w[ ideal active inactive achieved not_achieved parents terminal feasible ].freeze

  belongs_to :user
  belongs_to :parent, class_name: "Achievement", optional: true
  has_many :children, class_name: "Achievement", foreign_key: :parent_id, dependent: :restrict_with_exception
  has_many :challenges, as: :source, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :achieved_on, date: { allow_blank: true }

  scope :default_order, -> { order(id: :desc) }
  scope :ideal, -> { where(parent: nil) }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :achieved, -> { where.not(achieved_on: nil) }
  scope :not_achieved, -> { where(achieved_on: nil) }
  scope :parents, -> { where(id: select(:parent_id)) }
  scope :terminal, -> { where.not(id: parents) }
  scope :feasible, -> do
    not_achieved
      .where(id: achieved.parents)
      .or(not_achieved.terminal)
  end
  scope :applied_scopes, ->(scope_chains) do
    AppliedScopesQuery.new(self, APPLICABLE_SCOPE_NAMES).resolve(scope_chains)
  end

  def destroyable?
    !children.exists? && !challenges.exists?
  end

  def build_intermediate
    message_content = <<~CONTENT
      以下の情報をもとに、親と子の中間の実績に必要な情報を出力してください。

      Input:
      {
        [
          "parent_achievement"": {
            "name"": "#{parent.name}",
            "description": "#{parent.description}",
            "memo": "#{parent.memo}"
          },
          "child_achievement": {
            "name": "#{name}",
            "description": "#{description}",
            "memo": "#{memo}"
          }
        ]
      }
    CONTENT
    yml = YAML.load_file(Rails.root.join("app/models/achievement/build_intermediate_prompt.yml")).deep_symbolize_keys
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
    content_json = JSON.parse(content).deep_symbolize_keys
    parent.children.build(user:, name: content_json[:name], description: content_json[:description], memo: content_json[:memo])
  end

  def build_child
    message_content = <<~CONTENT
      以下の情報をもとに、子の実績に必要な情報を出力してください。

      Input:
      {
        "name": "#{name}",
        "description": "#{description}",
        "memo": "#{memo}"
      }
    CONTENT
    yml = YAML.load_file(Rails.root.join("app/models/achievement/build_child_prompt.yml")).deep_symbolize_keys
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
    content_json = JSON.parse(content).deep_symbolize_keys
    children.build(user: user, name: content_json[:name], description: content_json[:description], memo: content_json[:memo])
  end
end
