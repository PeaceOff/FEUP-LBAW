<div id="addFolder" class="modal fade col-md-6 col-md-offset-3">
    <div class="modal-content modal-out">
        <div class="modal-header text-center">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">Add Folder</h4>
        </div>
        <div class="modal-body">
            <form  id ="addFolder-form" action="../../actions/profile/action_add_folder.php" method="post" style="display:block">

                <div class="input-group form-group width-100">
                    <input class="hidden_projectId" type="hidden" name="project_id" value=""> </input>
                    <label for="descriptionArea">Folder Name</label>
                    <input type="text" class="form-control resizable-horizontal project_description" id="name" name="folderName" required>
                </div>

                <div class="text-center">
                    <input class="btn btn-success link_update_project" type="submit" name="add" value="Add" required="" tabindex="4">
                </div>

            </form>
        </div>
    </div>
</div>
