import MainView from '../../main';
import chartInitializer from "../../sensor/line_chart_config";

var currentChart, voltageChart, powerChart, energyChart, powerFactorChart, frequencyChart, uptimeChart;
var peakVelocityChart, rmsVelocityChart, peakVelocityCompChart, peakAccChart, rmsAccChart, highFreqRmsAcc, kurtosisChart, crestFactorChart;
var tempChart;

let vibrationchartsLoaded = false;
let temperatureChartsLoaded = false;

export default class View extends MainView {
  mount() {
    let that = this;
    
    $("#pills-data-history-tab").one("click", () => {
      this.renderElectricityCharts();
    });

    $("#v-pills-vibration-tab").one("click", () => {
      that.renderVibrationCharts();
    });

    $("#v-pills-temp-tab").one("click", () => {
      that.renderTemperatureCharts();
    });

  }

  unmount() {
    currentChart.destroy();
    voltageChart.destroy();
    powerChart.destroy();
    energyChart.destroy();
    powerFactorChart.destroy();
    frequencyChart.destroy();
    uptimeChart.destroy();
    peakVelocityChart.destroy();
    rmsVelocityChart.destroy();
    peakVelocityCompChart.destroy();
    peakAccChart.destroy();
    rmsAccChart.destroy();
    highFreqRmsAcc.destroy();
    kurtosisChart.destroy();
    crestFactorChart.destroy();
    tempChart.destroy();
    super.unmount();
  }

  renderElectricityCharts() {
    this.renderChart(currentChart, 'wet-pre-breaker-current-container', ["l1_current", "l2_current", "l3_current"], "Current", 25);
    this.renderChart(voltageChart, 'wet-pre-breaker-voltage-container', ["l1l2_voltage","l2l3_voltage","l3l1_voltage"], "Voltage", 26);
    this.renderChart(powerChart, 'wet-pre-breaker-power-container', ["active_power","reactive_power","apparent_power"], "Power", 27);
    this.renderChart(energyChart, 'wet-pre-breaker-energy-container', ["active_energy","reactive_energy"], "Energy", 28);
    this.renderChart(powerFactorChart, 'wet-pre-breaker-power-factor-container', ["avg_power_factor"], "Power Factor", 29);
    this.renderChart(frequencyChart, 'wet-pre-breaker-frequency-container', ["frequency"], "Frequency", 30);
    this.renderChart(uptimeChart, 'wet-pre-breaker-uptime-container', ["uptime"], "Uptime", 31);
  }

  renderVibrationCharts() {
    this.renderChart(peakVelocityChart, 'wet-pre-breaker-vib-peak-vel-container', ["x_axis","z_axis"], "vibration_peak_velocity_mm_sec", 15);
    this.renderChart(rmsVelocityChart, 'wet-pre-breaker-vib-rms-vel-container', ["x_axis","z_axis"], "vibration_rms_velocity_mm_sec", 16);
    this.renderChart(peakVelocityCompChart, 'wet-pre-breaker-vib-peak-vel-comp-container', ["x_axis","z_axis"], "vibration_peak_velocity_comp_freq_hz", 17);
    this.renderChart(peakAccChart, 'wet-pre-breaker-vib-peak-acc-container', ["x_axis","z_axis"], "vibration_peak_acceleration_g", 18);
    // this.renderChart(rmsAccChart, 'wet-pre-breaker-vib-rms-acc-container', ["x_axis","z_axis"], "vibration_rms_acceleration_g", 19);
    this.renderChart(highFreqRmsAcc, 'wet-pre-breaker-vib-high-freq-rms-acc-container', ["x_axis","z_axis"], "vibration_high_frequency_rms_acceleration_g", 20);
    this.renderChart(kurtosisChart, 'wet-pre-breaker-vib-kurtosis-container', ["x_axis","z_axis"], "vibration_kurtosis", 21);
    this.renderChart(crestFactorChart, 'wet-pre-breaker-vib-crest-factor-container', ["x_axis","z_axis"], "vibration_crest_factor", 22);
  }

  renderTemperatureCharts() {
    this.renderChart(tempChart, 'wet-pre-breaker-temp-container', ["temp"], "Temperature", 12);
  }
  
  renderChart(chart, container, value_keys, title, sensor_id) {
    let series = [];
    let seriesMap = {}; 
    let config = {title: title};
    let that = this;

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

    setTimeout(function(){ that.setChartData(seriesMap, series, chart, sensor_id); }, 250);
  }

  setChartData(seriesMap, series, chart, sensor_id) {
    for (let key in seriesMap) {
      this.get_data(sensor_id, key, chart, seriesMap[key])
    }
  }

  get_data(sensor_id, identifier, chart, series) {
    chart.showLoading();
    let url = `/sensor-data/${sensor_id}`;
    let data = {identifier: identifier}
    $.get(url, data, function(response_data, status){
      chart.series[series].setData(response_data.data, true);
      chart.hideLoading();
      chart.redraw()
    })
  }
}