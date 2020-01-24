import MainView from '../../main'
import liveView from "../../page/socket"
import tempChartObj from "../../page/temp_chart";

var chartTemp;

export default class View extends MainView {
  
  mount() {
    let channel = liveView();

    const element = document.getElementById('google-map')
    const options = {
      zoom: 0,
      center: new google.maps.LatLng(1.1700, 104.3000),
      disableDefaultUI: true
    }

    let position = new google.maps.LatLng(1.1700, 104.3000)

    const map = new google.maps.Map(element, options)

    new google.maps.Marker({
      position,
      animation: google.maps.Animation.DROP,
      map,
      title: "Site Location"
    })


    chartTemp = Highcharts.chart('dashboard-dryer-temperature-gauge-container', tempChartObj);

    channel.on("data_point", payload => {
      data = payload[key]["temp"]
      chartTemp.series[0].points[0].update(parseFloat(data))
    })
  }

  unmount() {
    chartTemp.destroy();
    super.unmount()
  }
}
