var pm2ChartObj =  {
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
        [0.03, '#55BF3B'], // green
        [0.08, '#FFFF00'],
        [0.13, '#EB8A14'], // yellow
        [0.4, '#FF0000'], // red
        [0.9, '#7E0023']
    ],
    min: 0,
    max: 400
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

  series: [{
    name: 'PM2.5',
    data: [0],
    dataLabels: {
        format: '<div style="text-align:center"><span style="font-size:20px;color:' +
            ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
               '<span style="font-size:12px;color:silver">ug/m3</span></div>'
    },
    tooltip: {
        valueSuffix: 'ug/m3'
    }
  }]
}

export default pm2ChartObj
