Rails.application.configure do
  # The VAPID public key is used to identify the server that is sending the web push notification.
  # To regenerate the VAPID keys, run the following command:
  # bin/rails runner "puts WebPush.generate_key.to_h.to_yaml"
  #
  # The Ruby WebPush library can produce a padded public key unnecessarily.
  # We delete the trailing "=" from the public key so we can subscribe in JavaScript
  # (i.e. registration.pushManager.subscribe({ applicationServerKey: webPushKey }))
  # with the raw key; otherwise we have to convert to a Uint8Array as most docs suggest
  # which is not necessary for the WebPush API and just doesn't feel like a nice API.
  #
  config.x.vapid.public_key = credentials.dig(:vapid, :public_key).to_s.delete("=")
  config.x.vapid.private_key = credentials.dig(:vapid, :private_key).to_s.delete("=")
  config.x.vapid.subject = credentials.dig(:vapid, :subject) # The "mailto:" email address
end
