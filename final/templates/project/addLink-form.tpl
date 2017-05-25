<div id="addLink" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content modal-out">

    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">Add link</h4>
    </div>

    <div class="modal-body">
      <form  id ="addLink-form" action="../../actions/project/action_add_link.php" method="post" style="display:block">

        <div class="form-group input-group">
          <span class="input-group-addon" ><i class="glyphicon glyphicon-link"></i></span>
          <input type="hidden" name="project_id" value="{$project.id}"> </input>
          <input class="form-control" type="url" pattern="https?://.+" tabindex="1" id="linkName" name="linkName" value="" required="" autofocus="" placeholder="Link">
        </div>

        <div class="text-center">
            <input class="btn btn-success " type="submit" name="create" value="Create" required="" tabindex="4">
        </div>

      </form>
    </div>
  </div>
</div>
