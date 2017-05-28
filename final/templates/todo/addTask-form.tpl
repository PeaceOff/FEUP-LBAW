<div id="createTask" class="modal fade">
<div class="display-flex"> 
<div class="col-xs-12 col-sm-6 col-sm-offset-3 col-md-4 col-md-offset-4">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">New Task</h4>
    </div>
    <div class="modal-body">
      <form  id ="createTask-form" action="../../actions/todo/action_add_task.php" method="post" style="display:block">
        <div class="input-group form-group width-100">
          <label for="title">Task Title</label>
          <input class="form-control" type="text" tabindex="1" id="title" name="title"  required="" autofocus="">
        </div>
	    <input type='hidden' name='project_id' value='{$project_id}'>
        <div class="form-group input-group width-100">
          <label for="sel_task_category">Category</label>
          <select class="form-control" id="sel_task_category" tabindex="2" name="category">
            {foreach from=$categories item=category}
            <option>{$category.name}</option>
            {/foreach}
          </select>
        </div>
        <div class="form-group input-group date width-100">
          <label for="task_deadline">Deadline</label>
          <input id="task_deadline" type='date' data-date-format="YYYY/MM/DD" name="deadline" class="datetimepicker form-control" tabindex="3">
        </div>
        <div class="form-group input-group width-100">
          <label for="task_description">Description</label>
          <textarea class="form-control resizable-horizontal" id="task_description" name="description" rows="3" tabindex="4"></textarea>
        </div>

        <div class="text-center">
          <input class="btn btn-success " type="submit" name="submit" value="Save" tabindex="5">
        </div>

      </form>
    </div>
  </div>
</div>
</div>
</div>

