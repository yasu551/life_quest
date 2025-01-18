import {TurboMount} from "turbo-mount";
import {registerComponent} from "turbo-mount/react";
import {HexColorPicker} from "react-colorful";
import HexColorPickerController from "./controllers/hex_color_picker_controller";

const turboMount = new TurboMount();

registerComponent(turboMount, "HexColorPicker", HexColorPicker, HexColorPickerController);
