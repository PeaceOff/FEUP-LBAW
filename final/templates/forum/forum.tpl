{foreach from=$forums item=forum}
<div id="forum_{$forum.id}" class="modal fade col-lg-6 col-lg-offset-3 col-md-8 col-md-offset-2 col-sm-12">
  <div class="modal-content">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">{$forum.name}</h4>
    </div>
    <div class="modal-body">
        <div class="panel panel-white post panel-shadow">
            <div class="modal-body">
                <form  class="addPost-form" action="../../api/add_topic_post.php" method="post" style="display:block">
                    <div class="form-group input-group width-100">
                        <label for="topicName">Write a new Post : </label>
                        <textarea class="form-control" type="text" tabindex="1" id="post_content" name="post_content" value="" required="" autofocus=""></textarea>
                        <input type="hidden" name="forum_id" value="{$forum.id}">
                        <input type="hidden" name="project_id" value="{$project_id}">
                    </div>
                    <div class="text-center">
                        <input class="btn btn-success " type="submit" name="create" value="Create" required="" tabindex="3">
                    </div>
                </form>
            </div>
        </div>
        <div class="post_space">
        </div>
    </div>
  </div>
</div>
{/foreach}

<script id="post_tmpl" type="text/x-jsrender">{literal}
<div class="panel panel-white post panel-shadow">
    <div class="post-heading">
        <div class="pull-left meta">
            <div class="title h5">
                <span>User <b>{{:poster}}</b></span>
                made a post.
            </div>
            <h6 class="text-muted time">{{:date}}</h6>
        </div>
    </div>
    <div class="post-description" style="clear : both;">
        <p>{{:content}}</p>
    </div>
    <button class="btn dropdown show_comments_button" data-toggle="collapse" data-target="#comments_{{:id}}"><i class="icon-chevron-right"></i>Show comments</button>
    <div class="post-footer collapse" id="comments_{{:id}}">
        <div class="input-group">
            <input class="form-control add_comment_input" name="content" placeholder="Add a comment" type="text">
            <span class="input-group-addon add_comment_button">
            <span><i class="fa fa-edit"></i></span>
            </span>
        </div>
        <ul id="comment_section_{{:id}}" class="comments-list">
        </ul>
    </div>
</div>{/literal}
</script>

<script id="comments_tmpl" type="text/x-jsrender">{literal}
<li class="comment">
    <div class="comment-body">
        <div class="comment-heading">
            <h4 class="user">{{:commenter}}</h4>
            <h5 class="time">{{:date}}</h5>
        </div>
        <p>{{:message}}</p>
    </div>
</li>{/literal}
</script>