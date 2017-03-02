
<div id="uploadFile" class=" modal fade col-md-6 col-md-offset-3">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4  class="modal-title">Upload file</h4>
    </div>
    <div class="modal-body">
      <form  id ="addFile-f" action="" method="post" style="display:block"  enctype="multipart/form-data">
        <div class="form-group">
          <input class="form-control" type="file" tabindex="1"  name="file" value="" required="" autofocus="">
        </div>

      </form>
      <h4> OR: </h4>
      <form  id ="uploadFile" action="save.php" method="post" style="display:block" class = "dropzone" enctype="multipart/form-data">
        <div class="dropzone-previews form-group fallback">
          <input name="file" type="file" multiple />
          <div class="dz-progress"><span class="dz-upload" data-dz-uploadprogress></span></div>

        </div>
      </form>

      <div class="text-center form-group" >
        <input class="btn btn-success" type="submit" tabindex="2" name="upload" value="Upload" required="">
      </div>
    </div>
  </div>
</div>
