import {TurboMountController} from "turbo-mount";

export default class extends TurboMountController {
  static targets = ["input", "mount"];

  get componentProps() {
    return {
      ...this.propsValue,
      onChange: this.onChange,
    };
  }

  onChange = (color) => {
    this.setComponentProps({...this.propsValue, color});
    this.inputTarget.value = color;
  };
}
