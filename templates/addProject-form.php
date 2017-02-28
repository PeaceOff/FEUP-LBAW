<div id="addProject" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content">
    <div class="modal-header text-center">
      <h4>New Project</h4>
    </div>
    <div class="modal-body">
      <form  id ="addProject-form" action="" method="post" style="display:block">
        <div class="form-group ">
          Name
          <input class="form-control" type="text" tabindex="1"  name="projectName" value="" required="">
        </div>
        <div class="form-group">
          Description
          <input class="form-control" type="text" tabindex="2"  name="description" value="" required="">
        </div>
        <div class="form-group ">
          Collaborators
          <input list="friends" class="form-control"  tabindex="3" name="friends">
            <datalist id="friends">
              <option value="João">
              <option value="David">
              <option value="Marcelo">
              <option value="José">
            </datalist>
        </div>
        <div class="col-sm-2 col-sm-offset-5 text-center">
          <input class="btn btn-success btn-block" type="submit" tabindex="4" name="create" value="Create" required="">
        </div>
      </form>
    </div>
  </div>
</div>
