$(document).ready(function(){

  var ctx = document.getElementById("statisticsChart").getContext('2d');

  var original = Chart.defaults.global.legend.onClick;

  Chart.defaults.global.legend.onClick = function(e, legendItem) {
    original.call(this, e, legendItem);
  };

  var myChart = new Chart(ctx, {
    type: 'horizontalBar',
    data: {
      labels: [],
      datasets: [{
        label: 'Projects',
        backgroundColor: "rgba(65,78,91,1)",
        data: [18],
      }, {
        label: 'Collaborations',
        backgroundColor: "rgba(236,177,36,1)",
        data: [30],
      },{
        label: 'Tasks Finished',
        backgroundColor: "rgba(20,183,90,1)",
        data: [24],
      }, {
        label: 'Tasks unfinished',
        backgroundColor: "rgba(34,34,34,1)",
        data: [15],
      }]
    },
    options: {
         scales: {
             yAxes: [{
                 ticks: {
                     beginAtZero: true
                 }
             }]
         }
     }
    });





});
