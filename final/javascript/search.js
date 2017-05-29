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
    var searchResultsElement = $('#searchResults');


    $.ajax({
        type:"post",
        url: "../../api/action_search_all.php",
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
                r['body'] = "<strong>" +value.name + ":</strong><br>" +  value.description;
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
                r['body'] =  "<strong>" + value.title + ":</strong><br>" + value.content;
                searchResults.push(r);
            });


            if(searchResults.length == 0){
                var template = $('.searchResult a').clone(true);
                template.find('.resultHeader').html("No results found");
                template.find('.resultHeader').removeClass("col-xs-7 col-sm-5 col-md-3 col-lg-3");
                template.find('.resultBody').remove();
                searchResultsElement.append(template);
            }else
                for (var i = 0 ; i < searchResults.length ; i++){
                    var template = $('.searchResult a').clone(true);

                    template.attr("href", searchResults[i]['link']);
                    template.find('.resultHeader').html(searchResults[i]['header']);
                    template.find('.resultBody').html(searchResults[i]['body']);

                    searchResultsElement.append(template);
                }


        }
    });
}

