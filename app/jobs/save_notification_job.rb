class SaveNotificationJob < ApplicationJob
  queue_as :default

  def perform(source_type:, source_id:)
    source = source_type.constantize.find_by(id: source_id)
    return if source.blank?

    source.save_notification
  end
end
