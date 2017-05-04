function setupForumListeners() {

    /*
    $("#addTopic").submit( function() {

        var topicName = $(this).find('#topicName').val();
        var project_id = $(this).find('#addTopic_project_id').val();

        console.log(topicName + " | " + project_id);

        $.ajax({
            url     : $(this).attr('action'),
            type    : $(this).attr('method'),
            dataType: 'json',
            data    : {'topicName' : topicName, 'project_id' : project_id},
        }).done(function(data) {

            alert("Submited");

        }).fail(function() {

            alert("Error");

        });
        return false;
    });
*/

    $('.forum_button').unbind().click(function() {//Listener que ao clicar num forum faz um pedido ajax dos posts

        var elem = $(this);
        var forum_id = elem.attr("data-target");
        var posts = $(forum_id).find('.post_space')[0];
        var topic_id = forum_id.replace('#forum_','');

        $.ajax({
            type: "post",
            dataType: "json",
            url: '../../api/get_post_by_topic.php',
            data: {'topic_id' : topic_id}
        }).done(function(data) {

            var template = $.templates("#post_tmpl");
            var htmlOutput = template.render(data);

            $(posts).html(htmlOutput);
            setupPostListeners();

        }).fail(function() {

            addWarning('warning','Could not load posts please try again later.');

        });

    });

    $('.delete_topic_button').unbind().click(function() {//Listener que ao clicar no trashbin de um forum apaga esse forum

        var elem = $(this);
        var proj_id = location.search.replace('?', '').split('=')[1];
        var topic_id = elem.parent().prev().children("button").attr("data-target");
        topic_id = topic_id.replace('#forum_','');

        $.ajax({
            type: "post",
            dataType: "json",
            url: '../../actions/forum/action_delete_forum_topic.php',
            data: {'topic_id' : topic_id, 'project_id' : proj_id}
        }).done(function(data) {

            elem.parent().parent().remove();
            addWarning('success','Topic deleted.');

        }).fail(function() {

            addWarning('warning','Could not delete topic please try again later.');

        });
    });
}

function setupPostListeners() {

    setupComments();

    $('.addPost-form').find("[name='post_content']").unbind().keypress(function (e) {
        var key = e.which;
        if(key == 13)  // the enter key code
        {
            $(this).parent().parent().find('[type="submit"]').click();
            return false;
        }
    });

    $('.addPost-form').unbind().submit(function(e) {

        var elem = $(this);
        var post_content = elem.find('#post_content').val();
        var project_id = elem.find('[name="project_id"]').val();
        var forum_id = elem.find('[name="forum_id"]').val();

        $.ajax({
            url     : '../../api/add_topic_post.php',
            type    : elem.attr('method'),
            dataType: 'json',
            data    : {'post_content' : post_content, 'project_id' : project_id, 'forum_id' : forum_id}
        }).done(function(data) {

            if(data){

                elem.find('#post_content').val("");
                elem.find('[type="submit"]').blur();

                var posts = $('#forum_' + forum_id).find('.post_space')[0];
                var template = $.templates("#post_tmpl");
                var htmlOutput = template.render(data);
                $(posts).prepend(htmlOutput);
                setupComments();


            } else {
                addWarning('warning','Could not create post please try again later.');
            }

        }).fail(function() {

            addWarning('warning','Could not create post please try again later.');

        });

        return false;

    });
}

function setupComments() {

    $('.show_comments_button').unbind().click(function() {

        var elem = $(this);

        var post_id = elem.attr("data-target");
        post_id = post_id.replace('#comments_','');

        $.ajax({
            type: "post",
            dataType: "json",
            url: '../../api/get_comments_by_post.php',
            data: {'post_id' : post_id}
        }).done(function(data) {

            if(elem.hasClass('collapsed')){
                return;
            }

            var comment_section = $('#comment_section_' + post_id);
            var template = $.templates("#comments_tmpl");
            var htmlOutput = template.render(data);
            comment_section.html(htmlOutput);

        }).fail(function() {

            addWarning('warning','Could not load comments please try again later.');

        });
    });

    $('.add_comment_input').unbind().keypress(function (e) {
        var key = e.which;
        if(key == 13)  // the enter key code
        {
            $(this).next().click();
            return false;
        }
    });

    $('.add_comment_button').unbind().click(function() {//Listener que ao clicar no trashbin de um forum apaga esse forum

        var elem = $(this);
        var proj_id = location.search.replace('?', '').split('=')[1];
        var post_id = elem.parent().parent().attr('id');
        post_id = post_id.replace('comments_','');
        var content = elem.prev().val();

        $.ajax({
            type: "post",
            dataType: "json",
            url: '../../actions/forum/action_add_post_comment.php',
            data: {'post_id' : post_id, 'project_id' : proj_id, 'content' : content}
        }).done(function(data) {

            elem.prev().val("");
            var template = $.templates("#comments_tmpl");
            var htmlOutput = template.render(data);
            elem.parent().next('ul').append(htmlOutput);

        }).fail(function() {

            addWarning('warning','Unable to comment please try again later.');

        });
    });

}

function clearAll(){
    $('#To-Do').empty();
    $('#Doing').empty();
    $('#Done').empty();
}

function category_ajax_call(category) {

    var string = "#" + category;
    var elem = $(string);

    var proj_id = location.search.replace('?', '').split('=')[1];

    $.ajax({
        type: "post",
        dataType: "json",
        url: '../../api/get_task_by_category.php',
        data: {'category' : category, 'project_id' : proj_id}
    }).done(function(data) {

        var template = $.templates("#api_tmpl");
        var htmlOutput = template.render(data);
        elem.html(htmlOutput);
        setup_information();

    }).fail(function() {

        addWarning('warning','Could not load tasks please try again later.');

    });
}

function setupTodoListeners() {

    $('#To-Do_button').click(function() {
        clearAll();
        category_ajax_call("To-Do");
    });

    $('#Doing_button').click(function() {

        clearAll();
        category_ajax_call("Doing");
    });

    $('#Done_button').click(function() {

        clearAll();
        category_ajax_call("Done");
    });
}