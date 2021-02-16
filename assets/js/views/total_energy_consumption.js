
// config object expects following keys to be set
export default function totalEnergychartInitializer(config) {
  
  return {
    title: {
        text: 'Total Energy Consumption'
    },
    xAxis: {
      type: 'datetime',
      labels: {
        format: '{value: %e %b %Y}'
      }
    },
    yAxis: [{
      title: {
          text: 'kWh',
          style: {
              color: Highcharts.getOptions().colors[0]
          }
      },
      labels: {
          format: '{value} kWh',
          style: {
              color: Highcharts.getOptions().colors[0]
          }
      }
    }],
    tooltip: {
        shared: true
    },
    legend: {
      enabled: false
    },
    series: [{
        name: 'kWh',
        type: 'column',
        data: [],
        tooltip: {
            valueSuffix: ' kWh'
        }

    }],
    exporting: {
      buttons: {
        contextButton: {
          menuItems: [
            "viewFullscreen",
            "printChart",
            "separator",
            "downloadPNG",
            "downloadJPEG",
            "downloadPDF",
            "downloadSVG",
            "downloadCSV"
          ]
        }
      }
    }
  }
}
