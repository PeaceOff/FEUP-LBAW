<div id="addProject" class="modal fade">
<div class="display-flex"> 
<div class="col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2 col-xs-12">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">New Project</h4>
    </div>
    <div class="modal-body">
      <form  id ="addProject-form" action="../../actions/profile/action_add_project.php" method="post" style="display:block">

        <div class="form-group ">
          <label for="projectName">Name</label>
          <input class="form-control" type="text" tabindex="1" id="projectName" name="projectName" value=""  autofocus=""  maxlength="19" required>
        </div>

        <div class="form-group input-group date width-100">
              <label for="deadline">Deadline</label>
              <input  type='date' data-date-format="YYYY/MM/DD" id="deadline" name="deadline" class="datetimepicker form-control" tabindex="2" required>
        </div>

        <div class="input-group form-group width-100">
              <label for="descriptionArea">Description</label>
              <textarea class="form-control resizable-horizontal" name="projectDescription" id="descriptionArea" rows="3" tabindex="3" required></textarea>
        </div>
        		
        <div class="text-center">
              <input class="btn btn-success " type="submit" name="create" value="Create"  tabindex="4">
        </div>
      
      </form>
    </div>
  </div>
</div>
</div>
</div>

