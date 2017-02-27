<?php
  include_once 'header.php';
 ?>

<!--button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#newProject">Open</button-->

<div id="newProject" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content">
    <div class="modal-header text-center">
      New project
    </div>
    <div class="modal-body">
      <form  id ="newProject-form" action="" method="post" style="display:block">
        <div class="form-group">
          <input class="form-control" type="text" tabindex="1" placeholder="Project Name" name="projectName" value="" required="">
        </div>
        <div class="form-group">
          <input class="form-control" type="text" tabindex="2" placeholder="Description" name="description" value="" required="">
        </div>
        <div class="form-group">
          <input list="friends" class="form-control" placeholder="Add colaborator" tabindex="3" name="friends">
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

<?php
  include_once 'footer.php';
 ?>
