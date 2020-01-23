import MainView from '../../main'
import liveView from "../../page/socket"
import tempChartObj from "../../page/temp_chart";

var tempChart, avgCurrentChart, avgVoltageChart, activePowerChart, activeEnergyChart;

export default class View extends MainView {
  
  mount() {
    let channel = liveView();

    let avgCurrentChartObj = Object.assign({}, tempChartObj, { title: {text: 'Avg. Current'} }, {
      series: [{
        name: 'Avg Current',
        data: [0],
        tooltip: {
            valueSuffix: " A"
        }
      }]
    })

    let avgVoltageChartObj = Object.assign({}, tempChartObj, { title: {text: 'Avg. Voltage'} }, {
      series: [{
        name: 'Avg Voltage',
        data: [0],
        tooltip: {
            valueSuffix: " V"
        }
      }]
    })

    let activePowerChartObj = Object.assign({}, tempChartObj, { title: {text: 'Active Power'} }, {
      series: [{
        name: 'Active Power',
        data: [0],
        tooltip: {
            valueSuffix: " W"
        }
      }]
    })

    let activeEnergyChartObj = Object.assign({}, tempChartObj, { title: {text: 'Active Energy'} }, {
      series: [{
        name: 'Active Energy',
        data: [0],
        tooltip: {
            valueSuffix: " J"
        }
      }]
    })

    tempChart = Highcharts.chart('dashboard-wet-pre-breaker-temperature-gauge-container', tempChartObj);
    avgCurrentChart = Highcharts.chart('dashboard-wet-pre-breaker-avg-current-gauge-container', avgCurrentChartObj);
    avgVoltageChart = Highcharts.chart('dashboard-wet-pre-breaker-avg-voltage-gauge-container', avgVoltageChartObj);
    activePowerChart = Highcharts.chart('dashboard-wet-pre-breaker-active-power-gauge-container', activePowerChartObj);
    activeEnergyChart = Highcharts.chart('dashboard-wet-pre-breaker-active-enery-gauge-container', activeEnergyChartObj);

    // channel.on("data_point", payload => {
    //   this.updateSensorWidgets(payload["sensor_data"]);
    // })

  }

  unmount() {
    chartTemp.destroy();
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
