import MainView from '../../main'
import liveView from "../../page/socket"
import tempChartObj from "../../page/temp_chart";

var chartTemp;

export default class View extends MainView {
  
  mount() {
    let channel = liveView();

    chartTemp = Highcharts.chart('dashboard-dryer-temperature-gauge-container', tempChartObj);

    channel.on("data_point", payload => {
      data = payload[key]["temp"]
      chartTemp.series[0].points[0].update(parseFloat(data))
    })
  }

  unmount() {
    chartTemp.destroy();
    super.unmount()
  }
}
