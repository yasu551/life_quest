class WebPushJob < ApplicationJob
  queue_as :default

  # MacOS, Chromeの通知表示領域に収まる文字数
  TITLE_MAX_LENGTH = 43
  BODY_MAX_LENGTH = 88

  def perform(push_subscription_id:, title:, body:, path: nil)
    push_subscription = PushSubscription.find_by(id: push_subscription_id)
    return if push_subscription.blank?

    message = {
      title: title.truncate(TITLE_MAX_LENGTH),
      body: body.truncate(BODY_MAX_LENGTH),
      icon: ActionController::Base.helpers.asset_url("icon-192.png"),
      data: {
        path:
      }
    }.to_json
    WebPush.payload_send(
      message:,
      endpoint: push_subscription.endpoint,
      p256dh: push_subscription.p256dh_key,
      auth: push_subscription.auth_key,
      vapid: {
        subject: Rails.configuration.x.vapid.subject,
        public_key: Rails.configuration.x.vapid.public_key,
        private_key: Rails.configuration.x.vapid.private_key
      }
    )
  end
end
