import MainView from "../main";
import {FormWizard} from './form_wizard';

export default class View extends MainView {
  mount() {
    let formwizard = new FormWizard
    formwizard.Constructor = FormWizard;
    formwizard.init();
  }

  unmount() {
    super.unmount();
  }
}
