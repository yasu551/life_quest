import {Controller} from "@hotwired/stimulus"
import {patch} from "@rails/request.js"

export default class extends Controller {
  static values = {elapsedTime: Number, url: String};

  initialize() {
    this.startTime = Date.now();
  }

  async disconnect() {
    const endTime = Date.now();
    const differenceSeconds = Math.floor((endTime - this.startTime) / 1_000);
    this.elapsedTimeValue += differenceSeconds;
    const body = JSON.stringify({
      task: {
        elapsed_time: this.elapsedTimeValue
      }
    });
    await patch(this.urlValue, {body});
  }
}
