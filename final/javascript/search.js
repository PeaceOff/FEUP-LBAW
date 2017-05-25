$(document).ready(function(){

  search();

});

function search(){


  $("#searchBtn").click(function() {
      var query = $("#searchQuery").val();
      console.log("Query: " + query);
      var searchResults = $('#searchResults');


      $.ajax({
        type:"post",
        url: "../../actions/search/action_search_all.php",
        data: {search_query: query , project_id: $_GET('project_id')},
        success: function (results){
            console.log(results);
            var res = JSON.parse(results);
            var tasks = res.tasks;
            var topics = res.topics;
            var posts = res.posts;

            searchResults.empty();
            $.each( tasks, function( i, value ) {
                var url = 'https://gnomo.fe.up.pt/~lbaw1665/final/pages/todo/todoPage.php?project_id=' + value.project_id + '&forum_task=' + value.id + '#' + value.category;
                searchResults.append("<li> <a href=" + url + ">" + "Task Name: " +  value.name + "  Task Description:"  + value.description + "</a> </li>")
            });

            $.each( topics, function( i, value ) {
                var url = 'https://gnomo.fe.up.pt/~lbaw1665/final/pages/project/projectPage.php?project_id=' + value.project_id + "&forum=" + value.id;
                searchResults.append("<li> <a href=" + url + ">" + "Topic Title:" + value.title +  "</a> </li>");
            });

            $.each( posts, function( i, value ) {
                var url = 'https://gnomo.fe.up.pt/~lbaw1665/final/pages/project/projectPage.php?project_id=' + value.project_id + "&forum=" + value.topic_id;
                searchResults.append("<li> <a href=" + url + ">" + "Post Content:" + value.content +  "</a> </li>");
            });


        }
      });


	});

  $("#searchQuery").keyup(function(e) {

      $("#searchBtn").click();
      return false;

  });

}
