<div id="addProject" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">New Project</h4>
    </div>
    <div class="modal-body">
      <form  id ="addProject-form" action="" method="post" style="display:block">
        <div class="form-group ">
          <label for="projectName">Name</label>
          <input class="form-control" type="text" tabindex="1" id="projectName" name="projectName" value="" required="" autofocus="">
        </div>
        <div class="form-group ">
          <label for="folderList">Folder</label>
          <input id = "folderList" list="folder" class="form-control"  tabindex="2" name="folder">
          <datalist id="folder">
            <option value="Folder1">
            <option value="Folder2">
            <option value="Folder3">
          </datalist>
        </div>
        <div class="input-group form-group width-100">
          <label for="descriptionArea">Description</label>
          <textarea class="form-control resizable-horizontal" id="descriptionArea" rows="3" tabindex="3"></textarea>
        </div>
        <div class="text-center">
          <input class="btn btn-success " type="submit" name="create" value="Create" required="" tabindex="4">
        </div>
      </form>
    </div>
  </div>
</div>
