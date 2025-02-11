module Notifiable
  extend ActiveSupport::Concern

  included do
    has_one :notification, as: :source, dependent: :destroy

    after_update if: -> { perform_at.blank? } do
      notification&.destroy
    end
    after_save if: -> { perform_at.present? && perform_at_previously_changed? && performed_at.blank? } do
      SaveNotificationJob.set(wait_until: perform_at).perform_later(source_type: self.class.name, source_id: id)
    end
    after_save if: -> { performed_at.present? } do
      notification&.destroy
    end
  end

  def save_notification
    title, body, path = notified_content.values_at(:title, :body, :path)
    body ||= ""
    path ||= "/"
    if notification&.persisted?
      notification.update(title:, body:, path:)
    else
      create_notification(title:, body:, path:)
    end
    WebPushJob.perform_later(push_subscription_id: push_subscription.id, notification_id: notification.id)
  end

  private

  def push_subscription
    raise NotImplementedError
  end

  def notified_content
    raise NotImplementedError
  end
end
