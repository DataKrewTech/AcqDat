import MainView from '../../main'
import liveView from "../../page/socket"
import tempChartObj from "../../page/temp_chart";

var chartTemp;

export default class View extends MainView {
  
  mount() {
    let channel = liveView();
    const device_ids = ['3108061e733a11e9a42fe86a64b144a9'];

    const element = document.getElementById('google-map')
    const options = {
      zoom: 0,
      center: new google.maps.LatLng(0.905497, 104.553407),
      disableDefaultUI: true
    }

    let position = new google.maps.LatLng(0.905497, 104.553407)

    const map = new google.maps.Map(element, options)

    new google.maps.Marker({
      position,
      animation: google.maps.Animation.DROP,
      map,
      title: "Site Location"
    })

    chartTemp = Highcharts.chart('dashboard-dryer-temperature-gauge-container', tempChartObj);

    device_ids.forEach(function(device_id, index){
      let url = `/api/devices/${device_id}/latest_data`;
      $.get(url, function(response_data, status){
        console.log(response_data);
        let data = response_data["sensor_data"]["DryerTemperature"]["temp"]
        chartTemp.series[0].points[0].update(parseFloat(data))
      })
    })

    channel.on("data_point", payload => {
      data = payload["sensor_data"]["DryerTemperature"]["temp"]
      chartTemp.series[0].points[0].update(parseFloat(data))
    })
  }

  unmount() {
    chartTemp.destroy();
    super.unmount()
  }
}
