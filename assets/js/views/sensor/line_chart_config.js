// config object expects following keys to be set
export default function chartInitializer(config) {
  return {
    rangeSelector: {
      selected: 5,
      buttons: [
        {
          type: "day",
          count: 1,
          text: "1d"
        },
        {
          type: "day",
          count: 3,
          text: "3d"
        },
        {
          type: "week",
          count: 1,
          text: "1w"
        },
        {
          type: "month",
          count: 1,
          text: "1m"
        },
        {
          type: "all",
          text: "All"
        }
      ]
    },

    title: {
      text: config.title
    },
    time: {
      timezone: 'Asia/Jakarta'
    },
    series: config.series,
    exporting: {
      buttons: {
        contextButton: {
          menuItems: ["viewFullscreen", "printChart", "separator", "downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadCSV"]
        }
      }
    }
  }
}
