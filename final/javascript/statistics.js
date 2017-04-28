$(document).ready(function(){

  var ctx = document.getElementById("statisticsChart").getContext('2d');

  var original = Chart.defaults.global.legend.onClick;

  Chart.defaults.global.legend.onClick = function(e, legendItem) {
    original.call(this, e, legendItem);
  };


  $.ajax({
  	type: "post",
	dataType:"json",
	url:'../../api/get_statistics.php',
	}).done(function(statistics){

      var myChart = new Chart(ctx, {
          type: 'horizontalBar',
          data: {
              labels: [],
              datasets: [{
                  label: 'Projects',
                  backgroundColor: "rgba(65,78,91,1)",
                  data: [statistics.own_proj_number],
              }, {
                  label: 'Collaborations',
                  backgroundColor: "rgba(236,177,36,1)",
                  data: [statistics.collab_proj_number],
              },{
                  label: 'Tasks Finished',
                  backgroundColor: "rgba(20,183,90,1)",
                  data: [statistics.task_finished_number],
              }, {
                  label: 'Tasks unfinished',
                  backgroundColor: "rgba(34,34,34,1)",
                  data: [statistics.task_unfinished_number],
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






});
