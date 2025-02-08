// Add a service worker for processing Web Push notifications:

self.addEventListener("push", async (event) => {
  const {title, ...options} = await event.data.json();
  event.waitUntil(self.registration.showNotification(title, options));
})

self.addEventListener("notificationclick", function (event) {
  event.notification.close()
  event.waitUntil(
    self.clients.matchAll({type: "window"}).then((clientList) => {
      const notificationPath = event.notification.data?.path;
      for (let i = 0; i < clientList.length; i++) {
        let client = clientList[i];
        let clientPath = (new URL(client.url)).pathname;

        if (notificationPath && clientPath === notificationPath && "focus" in client) {
          return client.focus();
        }
      }

      if (notificationPath && self.clients.openWindow) {
        return self.clients.openWindow(notificationPath);
      }
    })
  )
})
