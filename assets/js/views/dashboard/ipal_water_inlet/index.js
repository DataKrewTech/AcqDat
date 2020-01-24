import MainView from '../../main'
import liveView from "../../page/socket"
import tempChartObj from "../../page/temp_chart";
import phChartObj from "../../page/ph_chart";

var tempChart, phChart, conductivityChart, orpChart, turbidityChart;

export default class View extends MainView {
  mount() {
    let channel = liveView();

    const element = document.getElementById('google-map')
    const options = {
      zoom: 0,
      center: new google.maps.LatLng(1.1700, 104.3000)
    }

    let position = new google.maps.LatLng(1.1700, 104.3000)

    const map = new google.maps.Map(element, options)

    new google.maps.Marker({
      position,
      animation: google.maps.Animation.DROP,
      map,
      title: "Site Location"
    })

    tempChart = Highcharts.chart('dashboard-ipal-water-inlet-temp-gauge-container', tempChartObj);
    phChart = Highcharts.chart('dashboard-ipal-water-inlet-pH-gauge-container', phChartObj);

    channel.on("data_point", payload => {
      if (payload['device_id'] == '3108061e733a11e9a42fe86a64b144a9' ||
          payload['device_id'] == '4198846e10f511eaa4de0a3b7373b85d' ||
          payload['device_id'] == '77b0621010b911ea8139e2cdb2b6549d' ||
          payload['device_id'] == 'a18384fc10f811ea88ad0a3b7373b85d'
      ) {
        this.updateSensorWidgets(payload["sensor_data"]);
      }
    })
  }

  unmount() {
    tempChart.destroy();
    phChart.destroy();
    super.unmount()
  }

  updateSensorWidgets(payload) {
    for (var key in payload) {
      this.updateDashboardDom(key, payload)
    }
  }

  updateDashboardDom(key, payload) {
    switch(key) {
      case "pH": 
        let data = payload[key]["ph"];
        phChart.series[0].points[0].update(parseFloat(data));
        break;
      case "temperature":
        data = payload[key]["temp"]
        tempChart.series[0].points[0].update(parseFloat(data))
        break;
      case "Conductivity":
        data = payload[key]["cond"]
        $(".conductivity b").text(gx)
        break;
      case "Turbidity": 
        data = payload[key]["turbidity"]
        $(".turbidity b").text(gx)
        break;
      case "ORP":
        data = payload[key]["orp"]
        $(".orp b").text(gx)
        break;
    }
  }
}
