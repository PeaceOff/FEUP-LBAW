<div id="editCollaboration" class="modal fade col-md-6 col-md-offset-3">
    <div class="modal-content modal-out">
        <div class="modal-header text-center">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">Edit Collaboration</h4>
        </div>
        <div class="modal-body">
            <form  id ="editProject-form" action="../../actions/profile/action_edit_collaboration.php" method="post" style="display:block">


                <div class="form-group input-group width-100">
                    <label for="sel">Folder</label>
                    <select class="form-control project_folder" id="sel" tabindex="2" name="folder_id">
                        {foreach from=$folders2 item=folder}
                            <option value="{$folder.id}">
                                {$folder.name}
                            </option>
                        {/foreach}
                    </select>
                </div>

                <input class="hidden_collaboration_id" type="hidden" name="project_id" value=''> </input>

                <div class="text-center">
                    <input class="btn btn-success link_update_project" type="submit" name="edit" value="Edit" required="" tabindex="4">
                </div>

            </form>
        </div>
    </div>
</div>
