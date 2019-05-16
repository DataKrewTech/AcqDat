import MainView from "../main";
import chartInitializer from "./line_chart_config";

var chart;

export default class View extends MainView {
  mount() {
    let sensor_data = $("#sensor-highcharts-container").data()
    let value_keys = sensor_data.sensor.value_keys

    let series = [];
    let seriesMap = {}; 
    let config = {title: sensor_data.sensor.name};

    for(var key of value_keys) {
      series.push({
        name: key,
        data: []
      })
      seriesMap[key] = series.length -1;
    }

    config.series = series;
    
    let chartConfig = chartInitializer(config)
    chart = Highcharts.stockChart('sensor-highcharts-container', chartConfig);
    this.setChartData(seriesMap, series, chart, sensor_data.sensor.id)
  }

  unmount() {
    chart.destroy();
    super.unmount();
  }

  setChartData(seriesMap, series, chart, sensor_id) {
    for (let key in seriesMap) {
      this.get_data(sensor_id, key, chart, seriesMap[key])
    }
  }

  get_data(sensor_id, identifier, chart, series) {
    let url = `/sensor-data/${sensor_id}/${identifier}`;
    $.get(url, function(response_data, status){
      chart.series[series].setData(response_data.data, true)
      chart.redraw()
    })
  }
}
