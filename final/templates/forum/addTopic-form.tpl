<div id="addTopic" class="modal fade">
<div class="display-flex"> 
<div class="col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2 col-xs-12">
    <div class="modal-content modal-out">

        <div class="modal-header text-center">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">Add topic</h4>
        </div>

        <div class="modal-body">
            <form  id ="addTopic-form" action="../../actions/forum/action_add_forum_topic.php" method="post" style="display:block">

                <div class="form-group input-group width-100">
                    <label for="topicName">Name</label>
                    <input class="form-control" type="text" tabindex="1" id="topicName" name="topicName" value="" required="" >
                    <input type="hidden" id="addTopic_project_id" name="project_id" value="{$project_id}">
                </div>

                <div class="text-center">
                    <input class="btn btn-success " type="submit" name="create" value="Create" tabindex="2">
                </div>

            </form>

        </div>
    </div>
</div>
</div>
</div>

