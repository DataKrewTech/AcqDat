var pHChartObj = {
  chart: {
    type: 'solidgauge'
  },
  title: {
    text: 'pH'
  },
  pane: {
    center: ['50%', '85%'],
    size: '140%',
    startAngle: -90,
    endAngle: 90,
    background: {
      backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || '#EEE',
      innerRadius: '60%',
      outerRadius: '100%',
      shape: 'arc'
    }
  },

  exporting: {
    enabled: false
  },
  yAxis: {
    lineWidth: 0,
    minorTickInterval: null,
    tickAmount: 2,
    labels: {
      y: 15
    },
    stops: [
      [1, '#55BF3B'], // green
      [7, '#DDDF0D'], // yellow
      [14, '#DF5353'] // red
    ],
    min: 0,
    max: 12
  },

  plotOptions: {
    solidgauge: {
      dataLabels: {
        y: 1,
        borderWidth: 0,
        useHTML: false
      }
    }
  },
  time: {
    timezone: 'Asia/Jakarta'
  },
  series: [{
    name: 'pH',
    data: [0],
    dataLabels: {
      format: '<div style="text-align:center"><span style="font-size:20px;color:' +
        ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>'
    },
  }],
}

export default pHChartObj
