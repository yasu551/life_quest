import {Controller} from "@hotwired/stimulus"
import {marked} from "marked"

export default class extends Controller {
  static targets = ["input", "viewer"];
  static values = {visible: Boolean};

  toggleVisible() {
    this.visibleValue = !this.visibleValue;
  }

  visibleValueChanged() {
    if (this.visibleValue) {
      this.showViewer();
    } else {
      this.hideViewer();
    }
  }

  showViewer() {
    this.viewerTarget.innerHTML = marked.parse(this.inputTarget.value);
    this.inputTarget.classList.add("d-none");
    this.viewerTarget.classList.remove("d-none");
  }

  hideViewer() {
    this.inputTarget.classList.remove("d-none");
    this.viewerTarget.classList.add("d-none");
  }
}
