import MainView from '../main';
import liveView from "./socket";
import humidChartObj from "./humid_chart";
import tempChartObj from "./temp_chart";

var chartHumid;
var chartTemp

export default class View extends MainView {
  
  mount() {
    let sensor_data = $(".sensor-highcharts-container").data()
    console.log('sensor data', sensor_data);
    let channel = liveView();

    chartHumid = Highcharts.chart('container-humid-gauge', humidChartObj);
    chartTemp = Highcharts.chart('container-temperature-gauge', tempChartObj);

    channel.on("data_point", payload => {
      this.updateSensorWidgets(payload["sensor_data"]);
    })

  }

  unmount() {
    chartTemp.destroy();
    chartHumid.destroy();
    super.unmount()
  }

  updateSensorWidgets(payload) {
    for (var key in payload) {
      this.updateDashboardDom(key, payload)
    }
  }

  updateDashboardDom(key, payload) {
    switch(key) {
      case "Humidity": 
        let data = payload[key]["hum"];
        chartHumid.series[0].points[0].update(parseFloat(data));
        break;
      case "Temperature":
        data = payload[key]["temp"]
        chartTemp.series[0].points[0].update(parseFloat(data))
        break;
      case "Accelerometer": 
        let ax = payload[key]["ax"]
        let ay = payload[key]["ay"]
        let az = payload[key]["az"]
        $(".ax b").text(ax)
        $(".ay b").text(ay)
        $(".az b").text(az)
        break;
      case "Gyroscope":
        let gx = payload[key]["gx"]
        let gy = payload[key]["gy"]
        let gz = payload[key]["gz"]

        $(".gx b").text(gx)
        $(".gy b").text(gy)
        $(".gz b").text(gz)
        break;
      case "Light":
        let lum = payload[key]["lum"]
        $(".light_bulb b").text(lum)        
    }
  }
}
