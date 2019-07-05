<script>
import * as Highcharts from 'highcharts/highstock'
console.log(Highcharts)
import _ from 'lodash'
export let data

let names
$: if(data[0]) {
    names = [..._.keys(data[0].values), 'Total']
}
$: console.log(names)
$: console.log(data)
$: seriesOptions = names && names.map(name => {
    const seriesData = data.map(dataPoint => [(new Date(dataPoint.date)).valueOf(), name == 'Total'? dataPoint.value: dataPoint.values[name]])
    return {
        name,
        data: seriesData
    }
})

$: console.log(seriesOptions)

$: if(seriesOptions && seriesOptions.length) {
    renderChart()
}

function renderChart() {
    Highcharts.stockChart('container', {
        rangeSelector: {
            selected: 5 
        },
        yAxis: {
            labels: {
                formatter: function () {
                    return (this.value > 0 ? ' + ' : '') + this.value + '%';
                }
            },
            plotLines: [{
                value: 0,
                width: 2,
                color: 'silver'
            }]
        },
        // plotOptions: {
        //     series: {
        //         compare: 'percent',
        //         showInNavigator: true
        //     }
        // },
        tooltip: {
            pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b><br/>',
            valueDecimals: 2,
            split: true
        },
        series: seriesOptions
    })
};

</script>

<div>
    <div id="container"></div>
</div>