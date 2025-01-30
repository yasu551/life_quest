import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.resize();
    this.reconnect = this.reconnect.bind(this);
    window.addEventListener("turbo:morph", this.reconnect);
  }

  disconnect() {
    window.removeEventListener("turbo:morph", this.reconnect);
  }

  reconnect() {
    this.resize();
  }

  resize() {
    this.element.style.height = "auto";
    const margin = 40;
    this.element.style.height = `${this.element.scrollHeight + margin}px`;
  }
}
