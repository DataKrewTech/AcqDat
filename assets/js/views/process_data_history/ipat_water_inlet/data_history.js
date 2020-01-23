import MainView from '../../main';
import chartInitializer from "../../sensor/line_chart_config";

var phChart, conductivityChart, orpChart, turbidityChart, tempChart;

export default class View extends MainView {
  mount() {
    this.renderChart(phChart, 'ipal-water-inlet-ph-container', ["ph"], "pH", 9);
    this.renderChart(conductivityChart, 'ipal-water-inlet-conductivity-container', ["cond"], "Conductivity", 6);
    this.renderChart(orpChart, 'ipal-water-inlet-orp-container', ["orp"], "ORP", 11);
    this.renderChart(turbidityChart, 'ipal-water-inlet-turbidity-container', ["turbidity"], "Turbidiy", 24);
    this.renderChart(tempChart, 'ipal-water-inlet-temp-container', ["temp"], "Temperature", 8);
  }

  unmount() {
    phChart.destroy();
    conductivityChart.destroy();
    orpChart.destroy();
    turbidityChart.destroy();
    tempChart.destroy();
    super.unmount();
  }

  renderChart(chart, container, value_keys, title, sensor_id) {
    let series = [];
    let seriesMap = {}; 
    let config = {title: title};

    for(var key of value_keys) {
      series.push({
        name: key,
        data: []
      })
      seriesMap[key] = series.length -1;
    }

    config.series = series;
    
    let chartConfig = chartInitializer(config)
    chart = Highcharts.stockChart(container, chartConfig);
    this.setChartData(seriesMap, series, chart, sensor_id)
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