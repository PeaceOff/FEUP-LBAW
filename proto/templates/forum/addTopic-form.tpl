<div id="addTopic" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content modal-out">

    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">Add topic</h4>
    </div>

    <div class="modal-body">
      <form  id ="addTopic-form" action="../../actions/forum/action_add_forum_topic.php" method="post" style="display:block">

        <div class="form-group input-group width-100">
          <label for="topicName">Name</label>
          <input class="form-control" type="text" tabindex="1" id="topicName" name="topicName" value="" required="" autofocus="" >
	  <input type="hidden" name="project_id" value="{$project_id}"> </input>
        </div>

        <div class="text-center">
            <input class="btn btn-success " type="submit" name="create" value="Create" required="" tabindex="3">
        </div>

      </form>

    </div>
  </div>
</div>
