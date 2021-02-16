
// config object expects following keys to be set
export default function chartInitializer() {
  
  return {
    rangeSelector: {
      selected: 5,
      buttons: [
        {
          type: 'day',
          count: 1,
          text: '1d',
          },
          {
            type: 'day',
            count: 3,
            text: '3d',
          }, {
          type: 'week',
          count: 1,
          text: '1w'
        }, {
          type: 'month',
          count: 1,
          text: '1m'
        }, {
          type: 'all',
          text: 'All'
        }
      ]
    },
    chart: {
      zoomType: 'xy'
    },
    title: {
        text: 'Daily Avg Current and Voltage'
    },
    xAxis: {
      type: 'datetime',
      labels: {
        format: '{value: %e %b %Y}'
      }
    },
    yAxis: [{ // Primary yAxis
        labels: {
            format: '{value} A',
            style: {
                color: Highcharts.getOptions().colors[1]
            }
        },
        title: {
            text: 'Current',
            style: {
                color: Highcharts.getOptions().colors[1]
            }
        }
    }, { // Secondary yAxis
        title: {
            text: 'Voltage',
            style: {
                color: Highcharts.getOptions().colors[0]
            }
        },
        labels: {
            format: '{value} V',
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
        name: 'Avg Voltage',
        type: 'spline',
        yAxis: 1,
        data: [],
        tooltip: {
            valueSuffix: ' V'
        }

    }, {
        name: 'Avg Current',
        type: 'spline',
        data: [],
        tooltip: {
            valueSuffix: ' A'
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
