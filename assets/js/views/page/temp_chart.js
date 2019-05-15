var tempChartObj = {

  chart: {
      type: 'gauge',
      plotBackgroundColor: null,
      plotBackgroundImage: null,
      plotBorderWidth: 0,
      plotShadow: false
  },

  title: {
      text: 'Temperature'
  },

  pane: {
      startAngle: -150,
      endAngle: 150,
      background: [{
          backgroundColor: {
              linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
              stops: [
                  [0, '#FFF'],
                  [1, '#333']
              ]
          },
          borderWidth: 0,
          outerRadius: '109%'
      }, {
          backgroundColor: {
              linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
              stops: [
                  [0, '#333'],
                  [1, '#FFF']
              ]
          },
          borderWidth: 1,
          outerRadius: '107%'
      }, {
          // default background
      }, {
          backgroundColor: '#DDD',
          borderWidth: 0,
          outerRadius: '105%',
          innerRadius: '103%'
      }]
  },

  // the value axis
  yAxis: {
      min: 0,
      max: 200,

      minorTickInterval: 'auto',
      minorTickWidth: 1,
      minorTickLength: 10,
      minorTickPosition: 'inside',
      minorTickColor: '#666',

      tickPixelInterval: 30,
      tickWidth: 2,
      tickPosition: 'inside',
      tickLength: 10,
      tickColor: '#666',
      labels: {
          step: 2,
          rotation: 'auto'
      },
      title: {
          text: String.fromCharCode(176) + "C"
      },
      plotBands: [{
          from: 0,
          to: 50,
          color: '#55BF3B' // green
      }, {
          from: 50,
          to: 100,
          color: '#DDDF0D' // yellow
      }, {
          from: 100,
          to: 200,
          color: '#DF5353' // red
      }]
  },

  series: [{
      name: 'Temperature',
      data: [0],
      tooltip: {
          valueSuffix: String.fromCharCode(176) + "C"
      }
  }]

}

export default tempChartObj