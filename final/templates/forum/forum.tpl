<div id="forum_{$forum.id}" class="modal fade col-lg-6 col-lg-offset-3 col-md-8 col-md-offset-2 col-sm-12">
  <div class="modal-content ">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">{$forum.name}</h4>
    </div>
    <div class="modal-body">
        <div class="panel panel-white post panel-shadow">
            <div class="modal-body">
                <form  id ="addTopic-form" action="../../actions/forum/action_add_topic_post.php" method="post" style="display:block">
                    <div class="form-group input-group width-100">
                        <label for="topicName">Write a new Post : </label>
                        <textarea class="form-control" type="text" tabindex="1" id="post_content" name="post_content" value="" required="" autofocus=""></textarea>
                        <input type="hidden" name="forum_id" value="{$forum.id}"> </input>
                    </div>
                    <div class="text-center">
                        <input class="btn btn-success " type="submit" name="create" value="Create" required="" tabindex="3">
                    </div>
                </form>
            </div>
        </div>
      {foreach from=$forum.posts item=$post}
      <div class="panel panel-white post panel-shadow">
        <div class="post-heading">
          <div class="pull-left image">
            <img class="avatar img-circle" src="{$post.poster_img}" alt="avatar">
          </div>
          <div class="pull-left meta">
            <div class="title h5">
              <a href="#"><b>{$post.poster_name}</b></a>
              made a post.
            </div>
            <h6 class="text-muted time">{$post.time}</h6>
          </div>
        </div>
        <div class="pull-left"></div>
        <div class="post-description" style="clear : both;">
          <p>{$post.content}</p>
        </div>
        <button class="btn dropdown" data-toggle="collapse" data-target="#comments"><i class="icon-chevron-right"></i>Show comments</button>
        <div class="post-footer collapse" id="comments">
          <div class="input-group">
            <input class="form-control" placeholder="Add a comment" type="text">
            <span class="input-group-addon">
              <a href="#"><i class="fa fa-edit"></i></a>
            </span>
          </div>
          <ul class="comments-list">
            {foreach from=$post.comments item=comment}
            <li class="comment">
              <a class="pull-left" href="#">
                <img class="avatar img-circle" src="{$comment.commenter_img}" alt="avatar">
              </a>
              <div class="comment-body">
                <div class="comment-heading">
                  <h4 class="user">{$comment.commenter_name}</h4>
                  <h5 class="time">{$comment.time}</h5>
                </div>
                <p>{$comment.message}</p>
              </div>
            </li>
            {/foreach}
          </ul>
        </div>
      </div>
      {/foreach}
    </div>
  </div>
</div>
