<div id="editTask" class="modal fade col-xs-12 col-sm-6 col-sm-offset-3 col-md-4 col-md-offset-4">
  <div class="modal-content modal-out">

    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">Edit Task</h4>
    </div>

    <div class="modal-body">
      <form  id ="editTask-form" action="../../actions/todo/action_edit_task.php" method="post" style="display:block">
	<input type='hidden' name='project_id' value='{$project_id}'></input>
	<input type='hidden' class='task-id-handler' name='task_id' value=''></input>
	        
	<div class="form-group input-group width-100">
          <label for="sel1">Category</label>
          <select class="form-control task_category" id="sel1" tabindex="1" name="category">
            {foreach from=$categories item=category}
            <option>{$category.name}</option>
            {/foreach}
          </select>
        </div>
        
	<div class="form-group input-group date width-100">
          <label>Deadline</label>
          <input type='date' data-date-format="YYYY/MM/DD" name="deadline" class="datetimepicker form-control task_deadline" tabindex="2">
        </div>
        
	<div class="form-group input-group width-100">
          <label for="descriptionArea">Description</label>
          <textarea class="form-control resizable-horizontal task_description" id="descriptionArea" name="description" rows="3" tabindex="3"></textarea>
        </div>
        
	<div class="text-center">
         <input class="btn btn-success " type="submit" name="submit" value="Save" required="" tabindex="4">
        </div>
      
	</form>
    </div>
  </div>
</div>
