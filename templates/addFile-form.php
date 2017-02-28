<?php
  include_once 'header.php';
 ?>

<button type="button" name="button" data-toggle="modal" data-target = "#uploadFile">Carrega aqui</button>

<div id="uploadFile" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content">
    <div class="modal-header text-center">
      Upload file
    </div>
    <div class="modal-body">
      <form  id ="addFile-form" action="" method="post" style="display:block">
        <div class="form-group">
          <input class="form-control" type="file" tabindex="1"  name="file" value="" required="">
        </div>
        <div class="col-sm-2 col-sm-offset-5 text-center">
          <input class="btn btn-success btn-block" type="submit" tabindex="2" name="upload" value="Upload" required="">
        </div>
      </form>
    </div>
  </div>
</div>


<?php
  include_once 'footer.php';
 ?>
