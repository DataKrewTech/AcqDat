var vuMeterObj = {
  chart: {
        type: 'gauge',
        plotBorderWidth: 1,
        plotBackgroundColor: {
            linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
            stops: [
                [0, '#FFF4C6'],
                [0.3, '#FFFFFF'],
                [1, '#FFF4C6']
            ]
        },
        plotBackgroundImage: null,
        height: 200
    },

    title: {
        text: 'VU meter'
    },

    pane: {
        startAngle: -45,
        endAngle: 45,
        background: null,
        center: ['50%', '145%'],
        size: 300
    },

    exporting: {
        enabled: false
    },

    tooltip: {
        enabled: true 
    },

    yAxis: {
        min: -20,
        max: 6,
        minorTickPosition: 'outside',
        tickPosition: 'outside',
        labels: {
            rotation: 'auto',
            distance: 20
        },
        plotBands: [{
            from: 0,
            to: 6,
            color: '#C02316',
            innerRadius: '100%',
            outerRadius: '105%'
        }],
        pane: 0,
        title: {
            text: 'VU<br/><span style="font-size:8px">Channel A</span>',
            y: -40
        }
    },

    plotOptions: {
        gauge: {
            dataLabels: {
                enabled: true 
            },
            dial: {
                radius: '100%'
            }
        }
    },

    series: [{
        name: 'Channel A',
        data: [-20],
        yAxis: 0
    }],
  
}

export default vuMeterObj;