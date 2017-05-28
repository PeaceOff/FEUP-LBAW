<div id="editProject" class="modal fade">
<div class="display-flex"> 
<div class="col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2 col-xs-12">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">Edit Project</h4>
    </div>
    <div class="modal-body">
      <form  id ="editProject-form" action="../../actions/profile/action_edit_project.php" method="post" style="display:block">

	
        <div class="form-group input-group width-100">
          <label for="sel_project_folder">Folder</label>
          <select class="form-control project_folder" id="sel_project_folder" tabindex="2" name="folder_id">
            {foreach from=$folders2 item=folder}
              <option value="{$folder.id}">
                {$folder.name}
              </option>
            {/foreach}
          </select>
        </div>

	<div class="form-group input-group date width-100">
      <div class="form-inline">
        <label for="deadlineTask">Deadline</label>
        <input type="checkbox" name="check" value="Remove" class="remove_date">Remove
      </div>
        <input type='date' id="deadlineTask" data-date-format="YYYY/MM/DD" name="deadline" class="datetimepicker form-control project_deadline" tabindex="2" required>

    </div>
        
	<div class="input-group form-group width-100">
 	  <input class="hidden_projectId" type="hidden" name="project_id" value=""> 
          <label for="project_edition_description">Description</label>
          <textarea class="form-control resizable-horizontal project_description" id="project_edition_description" name="projectDescription" rows="3" tabindex="3" required></textarea>
        </div>

        <div class="text-center">
          <input class="btn btn-success link_update_project" type="submit" name="edit" value="Edit"  tabindex="4">
        </div>

      </form>
    </div>
  </div>
</div>
</div>
</div>

