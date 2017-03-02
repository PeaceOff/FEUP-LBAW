<?php
  include_once 'header.php';
 ?>

<button type="button" name="button" data-toggle="modal" data-target = "#uploadFile">Carrega aqui</button>

<div id="uploadFile" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content">
    <div class="modal-header text-center">
      <h4>Upload file</h4>
    </div>
    <div class="modal-body">
      <form  id ="addFile-form" action="" method="post" style="display:block">
        <div class="form-group">
          <input class="form-control" type="file" tabindex="1"  name="file" value="" required="">
        </div>
        <div class="text-center">
          <input class="btn btn-success" type="submit" tabindex="2" name="upload" value="Upload" required="">
        </div>
      </form>
    </div>
  </div>
</div>

<?php
  include_once 'footer.php';
 ?>
