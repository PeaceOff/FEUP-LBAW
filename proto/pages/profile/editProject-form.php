<div id="editProject" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">Edit Project</h4>
    </div>
    <div class="modal-body">
      <form  id ="editProject-form" action="../../actions/profile/action_edit_project.php" method="post" style="display:block">

        <div class="form-group ">
          <label for="projectName">Name</label>
          <input class="form-control" type="text" tabindex="1" id="projectName" name="projectName" value="" required="" autofocus="">
        </div>

        <div class="form-group input-group width-100">
          <label for="sel">Folder</label>
          <select class="form-control" id="sel" tabindex="2">
            <option>Folder1</option>
            <option>Folder2</option>
            <option>Folder3</option>
          </select>
        </div>

        <div class="input-group form-group width-100">
          <label for="descriptionArea">Description</label>
          <textarea class="form-control resizable-horizontal" id="descriptionArea" rows="3" tabindex="3"></textarea>
        </div>
        <div class="text-center">
          <input class="btn btn-success " type="submit" name="edit" value="Edit" required="" tabindex="4">
        </div>
      </form>
    </div>
  </div>
</div>
