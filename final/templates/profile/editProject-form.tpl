<div id="editProject" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">Edit Project</h4>
    </div>
    <div class="modal-body">
      <form  id ="editProject-form" action="../../actions/profile/action_edit_project.php" method="post" style="display:block">

	
        <div class="form-group input-group width-100">
          <label for="sel">Folder</label>
          <select class="form-control project_folder" id="sel" tabindex="2" value="">
            {foreach from=$folders2 item=folder}
              <option>
                {$folder.name}
              </option>
            {/foreach}
          </select>
        </div>

	<div class="form-group input-group date width-100">
          <label>Deadline</label>
          <input type='date' data-date-format="YYYY/MM/DD" name="deadline" class="datetimepicker form-control project_deadline" tabindex="2">
        </div>
        
	<div class="input-group form-group width-100">
 	  <input class="hidden_projectId" type="hidden" name="project_id" value=""> </input>
          <label for="descriptionArea">Description</label>
          <textarea class="form-control resizable-horizontal project_description" id="descriptionArea" name="projectDescription" rows="3" tabindex="3"></textarea>
        </div>

        <div class="text-center">
          <input class="btn btn-success link_update_project" type="submit" name="edit" value="Edit" required="" tabindex="4">
        </div>

      </form>
    </div>
  </div>
</div>
