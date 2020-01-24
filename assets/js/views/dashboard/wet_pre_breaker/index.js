import MainView from '../../main'
import liveView from "../../page/socket"
import tempChartObj from "../../page/temp_chart";
import vuMeterObj from "../../page/vu_meter";
var tempChart, avgCurrentChart, avgVoltageChart, activePowerChart, activeEnergyChart;

let avgCurrentChartObj = Object.assign({}, vuMeterObj, { title: { text: 'Avg. Current' } },
  {
    yAxis: {
      min: 0,
      max: 70,
      minorTickPosition: 'outside',
      tickPosition: 'outside',
      labels: {
        rotation: 'auto',
        distance: 10
      },
      plotBands: [{
        from: 50,
        to: 70,
        color: '#C02316',
        innerRadius: '100%',
        outerRadius: '105%'
      }],
      pane: 0,
      title: {
        text: 'VU<br/><span style="font-size:8px">Channel A</span>',
        y: -40
      }
    }
  },
  {
    series: [{
      name: 'Avg Current',
      data: [0],
      tooltip: {
        valueSuffix: " A"
      }
    }]
  })

let avgVoltageChartObj = Object.assign({}, vuMeterObj, { title: { text: 'Avg. Voltage' } },
  {
    yAxis: {
      min: 380,
      max: 450,
      minorTickPosition: 'outside',
      tickPosition: 'outside',
      labels: {
        rotation: 'auto',
        distance: 10
      },
      plotBands: [{
        from: 430,
        to: 450,
        color: '#C02316',
        innerRadius: '100%',
        outerRadius: '105%'
      }],
      pane: 0,
      title: {
        text: 'VU<br/><span style="font-size:8px">Channel A</span>',
        y: -40
      }
    }
  },
  {
    series: [{
      name: 'Avg Voltage',
      data: [380],
      tooltip: {
        valueSuffix: " V"
      }
    }]
  })

let activePowerChartObj = Object.assign({}, vuMeterObj, { title: { text: 'Active Power' } },

  {
    yAxis: {
      min: 0,
      max: 80,
      minorTickPosition: 'outside',
      tickPosition: 'outside',
      labels: {
        rotation: 'auto',
        distance: 10
      },
      plotBands: [{
        from: 60,
        to: 80,
        color: '#C02316',
        innerRadius: '100%',
        outerRadius: '105%'
      }],
      pane: 0,
      title: {
        text: 'VU<br/><span style="font-size:8px">Channel A</span>',
        y: -40
      }
    }
  },
  {
    series: [{
      name: 'Active Power',
      data: [0],
      tooltip: {
        valueSuffix: " W"
      }
    }]
  })

export default class View extends MainView {

  mount() {
    let channel = liveView();
    tempChart = Highcharts.chart('dashboard-wet-pre-breaker-temperature-gauge-container', tempChartObj);
    avgCurrentChart = Highcharts.chart('dashboard-wet-pre-breaker-avg-current-gauge-container', avgCurrentChartObj);
    avgVoltageChart = Highcharts.chart('dashboard-wet-pre-breaker-avg-voltage-gauge-container', avgVoltageChartObj);
    activePowerChart = Highcharts.chart('dashboard-wet-pre-breaker-active-power-gauge-container', activePowerChartObj);

    channel.on("data_point", payload => {
      if (payload['device_id'] == "309efbba119111eaaa47b6b16018c425" || 
      payload['device_id'] == "93b92b9a31e311ea8ed34eb4d13005bf") 
      {
        this.updateSensorWidgets(payload["sensor_data"]);
      }
      console.log(payload);
    })
  }

  unmount() {
    tempChart.destroy();
    avgVoltageChart.destroy();
    activePowerChart.destroy();
    avgCurrentChart.destroy();
    super.unmount()
  }

  updateSensorWidgets(payload) {
    for (var key in payload) {
      this.updateDashboardDom(key, payload)
    }
  }

  updateDashboardDom(key, payload) {
    switch (key) {
      case "Temperature":
        let data = payload[key]["temp"]
        tempChart.series[0].points[0].update(parseFloat(data));
        break;
      case "Current":
        data = (payload[key]["l1_current"] + payload[key]["l2_current"] + payload[key]["l3_current"])/3;
        avgCurrentChart.series[0].points[0].update(parseFloat(data));
        break;
      case "Voltage":
        data = (payload[key]["l1l2_voltage"] + payload[key]["l2l3_voltage"] + payload[key]["l3l1_voltage"])/3;
        avgVoltageChart.series[0].points[0].update(parseFloat(data))
        break;
      case "Power":
        data = payload[key]["active_power"]
        activePowerChart.series[0].points[0].update(parseFloat(data))
      case "Energy":
        data = payload[key]["active_energy"]
        $(".total_energy b").text(data)
        break;
    }
  }
}
