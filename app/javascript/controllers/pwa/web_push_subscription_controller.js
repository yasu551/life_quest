import {Controller} from "@hotwired/stimulus"
import {post, destroy} from "@rails/request.js"

export default class extends Controller {
  static targets = ["subscribeButton", "unsubscribeButton"];

  async connect() {
    this.registration = await navigator.serviceWorker.ready;
    this.subscription = await this.registration.pushManager.getSubscription();
    this.notificationPermission = await this.#getNotificationPermission();
    this.vapidPublicKey = document.querySelector("meta[name='vapid-public-key']").content;
    if (this.subscription) {
      this.#disableSubscribeButton();
      this.#enableUnsubscribeButton();
    } else {
      this.#enableSubscribeButton();
      this.#disableUnsubscribeButton();
    }
  }

  async subscribe() {
    if (this.registration && !this.subscription) {
      console.log("Subscribing to push notifications");
      this.#disableSubscribeButton();
      if (this.notificationPermission) {
        this.subscription = await this.registration.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: this.vapidPublicKey
        });
        const {endpoint, p256dh, auth} = this.#getSubscriptionDetails();
        const body = JSON.stringify({
          endpoint,
          p256dh_key: p256dh,
          auth_key: auth
        });
        await post("/push_subscriptions", {body});
        this.#enableUnsubscribeButton();
      } else {
        this.#enableSubscribeButton()
      }
    }
  }

  async unsubscribe() {
    if (this.subscription) {
      console.log("Unsubscribing from push notifications");
      this.#disableUnsubscribeButton();
      await this.subscription.unsubscribe();
      const {endpoint, p256dh, auth} = this.#getSubscriptionDetails();
      const body = JSON.stringify({
        endpoint,
        p256dh_key: p256dh,
        auth_key: auth
      });
      await destroy("/push_subscriptions", {body});
      this.subscription = null;
      this.#enableSubscribeButton();
    }
  }

  async #getNotificationPermission() {
    console.log(`Permission to receive notifications has been ${Notification.permission}`);
    switch (Notification.permission) {
      case "granted":
        return Promise.resolve(true);
      case "denied":
        return Promise.resolve(false);
      default:
        const permission = await Notification.requestPermission();
        console.log(`Permission to receive notifications has been ${permission}`);
        return Promise.resolve(permission === "granted");
    }
  }

  #getSubscriptionDetails() {
    if (this.subscription) {
      const {endpoint, expirationTime, keys: {p256dh, auth}} = this.subscription.toJSON();
      return {endpoint, expirationTime, p256dh, auth};
    }
  }

  #enableSubscribeButton() {
    this.subscribeButtonTarget.disabled = false;
  }

  #disableSubscribeButton() {
    this.subscribeButtonTarget.disabled = true;
  }

  #enableUnsubscribeButton() {
    this.unsubscribeButtonTarget.disabled = false;
  }

  #disableUnsubscribeButton() {
    this.unsubscribeButtonTarget.disabled = true;
  }
}
