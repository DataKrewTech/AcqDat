import MainView from '../../main';
import chartInitializer from "../../sensor/line_chart_config";

var chart;

export default class View extends MainView {
  mount() {
    let value_keys = ["temp"]

    let series = [];
    let seriesMap = {}; 
    let config = {title: "DryerTemperature"};

    for(var key of value_keys) {
      series.push({
        name: key,
        data: []
      })
      seriesMap[key] = series.length -1;
    }

    config.series = series;
    
    let chartConfig = chartInitializer(config)
    chart = Highcharts.stockChart('dryer-temp-container', chartConfig);
    this.setChartData(seriesMap, series, chart, 1)
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
    let url = `/sensor-data/${sensor_id}`;
    let data = {identifier: identifier}
    $.get(url, data, function(response_data, status){
      chart.series[series].setData(response_data.data, true)
      chart.redraw()
    })
  }
}