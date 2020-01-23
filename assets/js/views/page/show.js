import MainView from '../main';
import liveView from "./socket";
import humidChartObj from "./humid_chart";
import tempChartObj from "./temp_chart";
import pm2ChartObj from "./pm2_chart";

var chartHumid;
var chartTemp;
var chartpm2;
var chartTemp2, chartTemp3, chartCurrent, chartVoltage, chartVoltage, chartPower,
  chartEnergy, chartpH, chartConductivity, chartORP, chartTurbidity;

export default class View extends MainView {
  
  mount() {
    let channel = liveView();

    // chartHumid = Highcharts.chart('container-humid-gauge', humidChartObj);
    chartTemp = Highcharts.chart('container-temperature-gauge', tempChartObj);
    // chartpm2 = Highcharts.chart('container-pm2-gauge', pm2ChartObj);

    chartTemp2 = Highcharts.chart('container-temperature2-gauge', tempChartObj);
    chartCurrent = Highcharts.chart('container-current-gauge', tempChartObj);
    chartVoltage = Highcharts.chart('container-voltage-gauge', tempChartObj);
    chartPower = Highcharts.chart('container-power-gauge', tempChartObj);
    chartEnergy = Highcharts.chart('container-energy-gauge', tempChartObj);
    chartpH = Highcharts.chart('container-pH-gauge', tempChartObj);
    chartConductivity = Highcharts.chart('container-conductivity-gauge', tempChartObj);
    chartORP = Highcharts.chart('container-ORP-gauge', tempChartObj);
    chartTurbidity = Highcharts.chart('container-turbidity-gauge', tempChartObj);
    chartTemp3 = Highcharts.chart('container-temperature3-gauge', tempChartObj);

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
      case "Pm2.5":
        data = payload[key]["ug/m3"]
        chartpm2.series[0].points[0].update(parseFloat(data))
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
