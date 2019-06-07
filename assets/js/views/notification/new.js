import MainView from "../main";

export default class View extends MainView {
  mount() {
    var FormWizard = function() {};
    FormWizard.prototype.createVertical = function($form_container) {
      $form_container.steps({
          headerTag: "h3",
          bodyTag: "section",
          transitionEffect: "fade",
          stepsOrientation: "vertical"
      });
      return $form_container;
    },
    FormWizard.prototype.init = function() {
      this.createVertical($("#wizard-vertical"));
    }

    let formwizard = new FormWizard
    formwizard.Constructor = FormWizard;
    formwizard.init();
  }

  unmount() {
    super.unmount();
  }
}
