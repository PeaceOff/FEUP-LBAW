$(document).ready(function(){
    var queryElemet = $("#searchQuery");


    queryElemet.focus(function (e) {
        searchHandler();
    })


    $(document).click(function(e) {
       $('#searchResults').empty();
    });

    queryElemet.keyup(function(e) {
        searchHandler();
        return false;
    });

});


function searchHandler(){
    var query = $("#searchQuery").val();
    console.log("Query: " + query);
    var searchResultsElement = $('#searchResults');


    $.ajax({
        type:"post",
        url: "../../actions/search/action_search_all.php",
        data: {search_query: query , project_id: $_GET('project_id')},
        success: function (results){

            var res = JSON.parse(results);
            var tasks = res.tasks;
            var topics = res.topics;
            var posts = res.posts;


            var searchResults = [];

            searchResultsElement.empty();
            $.each( tasks, function( i, value ) {
                var r = {};
                r['link'] = 'https://gnomo.fe.up.pt/~lbaw1665/final/pages/todo/todoPage.php?project_id=' + value.project_id + '&forum_task=' + value.id + '#' + value.category;
                r['header']= "Task"
                r['body'] = value.name + " : " +  value.description;
                searchResults.push(r);
            });

            $.each( topics, function( i, value ) {
                var r = {};
                r['link'] = 'https://gnomo.fe.up.pt/~lbaw1665/final/pages/project/projectPage.php?project_id=' + value.project_id + "&forum=" + value.id;
                r['header'] = "Topic"
                r['body'] =  value.title;
                searchResults.push(r);
            });

            $.each( posts, function( i, value ) {
                var r = {};
                r['link'] = 'https://gnomo.fe.up.pt/~lbaw1665/final/pages/project/projectPage.php?project_id=' + value.project_id + "&forum=" + value.topic_id;
                r['header'] = "Post"
                r['body'] =  value.content;
                searchResults.push(r);
            });

            console.log(searchResults);

            for (var i = 0 ; i < searchResults.length ; i++){
                var template = $('.searchResult a').clone(true);

                template.attr("href", searchResults[i]['link']);
                template.find('.resultHeader').text(searchResults[i]['header']);
                template.find('.resultBody').text(searchResults[i]['body']);

                console.log(template);
                searchResultsElement.append(template);
            }


        }
    });
}

