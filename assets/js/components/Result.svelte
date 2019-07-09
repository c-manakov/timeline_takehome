<script>
  import * as Highcharts from "highcharts/highstock";
  import _ from "lodash";
  export let data;

  let names;
  $: if (data[0]) {
    names = [..._.keys(data[0].values), "Total"];
  }
  $: seriesOptions =
    names &&
    names.map(name => {
      const seriesData = data.map(dataPoint => [
        new Date(dataPoint.date).valueOf(),
        name == "Total" ? dataPoint.value : dataPoint.values[name]
      ]);
      return {
        name,
        data: seriesData
      };
    });

  $: if (seriesOptions && seriesOptions.length) {
    renderChart();
  }

  function renderChart() {
    Highcharts.stockChart("graph", {
      rangeSelector: {
        selected: 5
      },
      yAxis: {
        labels: {
          formatter: function() {
            return (this.value > 0 ? " + " : "") + this.value + "%";
          }
        },
        plotLines: [
          {
            value: 0,
            width: 2,
            color: "silver"
          }
        ]
      },
      tooltip: {
        pointFormat:
          '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b><br/>',
        valueDecimals: 2,
        split: true
      },
      series: seriesOptions
    });
  }
</script>

<style>
  p {
    height: min-content;
    align-self: center;
    font-size: 30px;
    font-weight: bold;
  }
  #graph {
    height: 450px;
    background-color: #f2f2f2;
    display: flex;
    width: 65%;
    flex-direction: row;
    align-content: center;
    justify-content: center;
    border-radius: 0.28571429rem;
    box-shadow: 0 1px 3px 0 #d4d4d5, 0 0 0 1px #d4d4d5;
  }
</style>

<div id="graph">
  <p>Graph is gonna be here</p>
</div>
