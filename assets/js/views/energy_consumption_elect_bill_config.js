
// config object expects following keys to be set
export default function energychartInitializer(config) {
  
  return {
    chart: {
        zoomType: 'xy'
    },
    title: {
        text: 'Daily Energy Consumption and Electricity Bill'
    },
    xAxis: {
      type: 'datetime',
      labels: {
        format: '{value: %e %b %Y}'
      }
    },
    yAxis: [{ // Primary yAxis
        labels: {
            format: '{value} IDR',
            style: {
                color: Highcharts.getOptions().colors[1]
            }
        },
        title: {
            text: 'IDR',
            style: {
                color: Highcharts.getOptions().colors[1]
            }
        }
    }, { // Secondary yAxis
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
        },
        opposite: true
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
        yAxis: 1,
        data: [],
        tooltip: {
            valueSuffix: ' kWh'
        }

    }, {
        name: 'IDR',
        type: 'spline',
        data: [],
        tooltip: {
            valueSuffix: ' IDR'
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
