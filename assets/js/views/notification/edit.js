import MainView from '../main';

export default class View extends MainView {
  mount() {
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

  unmount() {
    super.unmount();
  }

}
