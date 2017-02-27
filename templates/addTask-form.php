<div id="addTask" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content">
    <div class="modal-header text-center">
      New task
    </div>
    <div class="modal-body">
      <form  id ="addTask-form" action="" method="post" style="display:block">
        <div class="form-group">
          <input class="form-control" type="text" tabindex="1" placeholder="Task Name" name="taskName" value="" required="">
        </div>
        <div class="form-group">
          <input class="form-control" type="text" tabindex="2" placeholder="Description" name="description" value="" >
        </div>
        <div class="form-group">
          <input class="form-control" type="date" tabindex="3" name="date" >
        </div>
        <div class="col-sm-2 col-sm-offset-5 text-center">
          <input class="btn btn-success btn-block" type="submit" tabindex="4" name="create" value="Create" required="">
        </div>
      </form>
    </div>
  </div>
</div>
