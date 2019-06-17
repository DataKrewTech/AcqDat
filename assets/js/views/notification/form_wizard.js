function FormWizard() {}

FormWizard.prototype.createVertical = function($form_container) {
  $form_container.steps({
      headerTag: "h3",
      bodyTag: "section",
      transitionEffect: "fade",
      stepsOrientation: "vertical",
      labels: {
        finish: "Submit"
      },
      onStepChanging: function(event, currentIndex, newIndex) {
        let result = handleChangingEvent(event, currentIndex, newIndex);
        return result;
      },
      onFinished: function (event, currentIndex) {
        $("#wizard-vertical").submit();
      }
  });
  return $form_container;
}

FormWizard.prototype.init = function() {
  this.createVertical($("#wizard-vertical"));
}

function handleChangingEvent(event, currentIndex, newIndex) {

  switch (currentIndex) {
    case 0: 
      return setSensorStep()
      
    case 1:
      return rulesSetup()

    case 2:
      return true
      
    default: 
      return false
  }
}

function setSensorStep() {
  let device_id = $("select.device option:selected").val()
  let target_div = $("select.sensor")
  $("span.loader").show()

  $.ajax({
    type: "GET",
    url: "/device-sensors/" + device_id,
    success: function(data) {
      target_div.empty().append(data.html).selectpicker('refresh');
      $("span.loader").hide();
    }

  })
  return true;  
}


function rulesSetup() {
  let sensor_id = $("select.sensor option:selected").val()
  let target_div = $("div#configure-rules")
  $("span.loader").show()

  $.ajax({
    type: "GET",
    url: "/notification-configuration/" + sensor_id,
    success: function(data) {
      target_div.empty().append(data.html);
      $("span.loader").hide();
      $("select.rules").selectpicker('refresh');
      rule_prefrences();
    }
  })
  
  return true;
}

function rule_prefrences() {
  $("select.rules").on('change', function (e) {
    let key = e.currentTarget.id
    let value = e.currentTarget.value;
    let CSRF_TOKEN = $("meta[name='csrf-token']").attr("content");
    let request_data = {module: value, key: key}
    let target_div = $('#rule-configuration-' + key)

    if (value !== "-1" ) {
      $.ajax({
        url: "/notification/rule_preferences",
        type: "POST",
        beforeSend: function(xhr) {
          xhr.setRequestHeader("X-CSRF-Token", CSRF_TOKEN);
        },
        data: request_data,
        success: function(data) {          
          target_div.append(data.html)
        }
      });
    } else {
      return true;
    }
  })
}

export {FormWizard};
