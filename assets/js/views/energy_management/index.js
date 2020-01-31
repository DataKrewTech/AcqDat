import MainView from '../main';
import chartInitializer from "../current_voltage_config";
import energychartInitializer from "../energy_consumption_elect_bill_config";


var currentVoltageChart, energyBillChart;

export default class View extends MainView {
  mount() {
    this.renderChart(currentVoltageChart, 'container-current-voltage-line');
    this.renderEnergyBillChart(energyBillChart, 'container-energy-bill-column');
  }

  unmount() {
    currentVoltageChart.destroy();
    energyBillChart.destroy();
    super.unmount();
  }

  renderChart(chart, container) {
    let chartConfig = chartInitializer()
    chart = Highcharts.chart(container, chartConfig);
    this.get_current_voltage_data(chart)
  }

  renderEnergyBillChart(chart, container) {
    let chartConfig = energychartInitializer()
    chart = Highcharts.chart(container, chartConfig);
    this.get_energy_consumption_bill(chart)
  }

  get_energy_consumption_bill(chart) {
    let url = `/energy-consumption-electricity-bill`;
    $.get(url, {}, function(response_data, status){
      let daily_energy_consumption = response_data.data.daily_energy_consumption.map(x => [new Date(x[0]).getTime(), x[1]]);
      let daily_bill = response_data.data.daily_bill.map(x => [new Date(x[0]).getTime(), x[1]]);

      chart.series[0].setData(daily_energy_consumption, true)
      chart.series[1].setData(daily_bill, true)
      chart.redraw()      
    })
  }

  get_current_voltage_data(chart) {
    let url = `/current-voltage-senor-data`;
    $.get(url, {}, function(response_data, status){
      let avg_current_data = response_data.data.avg_current.map(x => [new Date(x[0]).getTime(), x[1]]);
      let avg_voltage_data = response_data.data.avg_voltage.map(x => [new Date(x[0]).getTime(), x[1]]);

      chart.series[0].setData(avg_voltage_data, true)
      chart.series[1].setData(avg_current_data, true)
      chart.redraw()
    })
  }
}