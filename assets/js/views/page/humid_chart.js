var humidChartObj =  {
  chart: {
    type: 'solidgauge'
  },
  title: null,
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

  yAxis: {
    lineWidth: 0,
    minorTickInterval: null,
    tickAmount: 2,
    labels: {
        y: 16
    },
    stops: [
        [0.1, '#55BF3B'], // green
        [0.5, '#DDDF0D'], // yellow
        [0.9, '#DF5353'] // red
    ],
    min: 0,
    max: 100
  },

  plotOptions: {
    solidgauge: {
        dataLabels: {
            y: 5,
            borderWidth: 0,
            useHTML: false
        }
    }
  },
  time: {
    timezone: 'Asia/Jakarta'
  },
  series: [{
    name: 'Humidity',
    data: [0],
    dataLabels: {
        format: '<div style="text-align:center"><span style="font-size:20px;color:' +
            ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
               '<span style="font-size:12px;color:silver">%</span></div>'
    },
    tooltip: {
        valueSuffix: '%'
    }
  }],
}

export default humidChartObj
