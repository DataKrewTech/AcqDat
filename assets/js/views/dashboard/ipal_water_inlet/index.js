import MainView from '../../main'
import liveView from "../../page/socket"
import tempChartObj from "../../page/temp_chart";

var tempChart, phChart, conductivityChart, orpChart, turbidityChart;

export default class View extends MainView {
  mount() {
    let channel = liveView();

    let phChartObj = Object.assign({}, tempChartObj, { title: {text: 'pH'} }, {
      series: [{
        name: 'pH',
        data: [0],
        tooltip: {
            valueSuffix: " pH"
        }
      }]
    })

    let conductivityChartObj = Object.assign({}, tempChartObj, { title: {text: 'Conductivity'} }, {
      series: [{
        name: 'Conductivity',
        data: [0],
        tooltip: {
            valueSuffix: " S/m"
        }
      }]
    })

    let orpChartObj = Object.assign({}, tempChartObj, { title: {text: 'ORP'} }, {
      series: [{
        name: 'ORP',
        data: [0],
        tooltip: {
            valueSuffix: " mV"
        }
      }]
    })

    let turbidityChartObj = Object.assign({}, tempChartObj, { title: {text: 'Turbidity'} }, {
      series: [{
        name: 'Turbidity',
        data: [0],
        tooltip: {
            valueSuffix: " FTU"
        }
      }]
    })

    phChart = Highcharts.chart('dashboard-ipal-water-inlet-pH-gauge-container', phChartObj);
    conductivityChart = Highcharts.chart('dashboard-ipal-water-inlet-conductivity-gauge-container', conductivityChartObj);
    orpChart = Highcharts.chart('dashboard-ipal-water-inlet-orp-gauge-container', orpChartObj);
    turbidityChart = Highcharts.chart('dashboard-ipal-water-inlet-turbidity-gauge-container', turbidityChartObj);
    tempChart = Highcharts.chart('dashboard-ipal-water-inlet-temp-gauge-container', tempChartObj);

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
