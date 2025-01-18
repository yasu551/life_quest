import {Controller} from "@hotwired/stimulus"
import SlimSelect from "slim-select"

export default class extends Controller {
  connect() {
    this.create();
    this.reconnect = this.reconnect.bind(this);
    window.addEventListener("turbo:morph", this.reconnect);
  }

  disconnect() {
    window.removeEventListener("turbo:morph", this.reconnect);
  }

  reconnect = event => {
    this.create();
  }

  create() {
    if (this.slimSelect) {
      this.slimSelect.destroy();
    }
    this.slimSelect = new SlimSelect({
      select: this.element,
    });
  }
}
