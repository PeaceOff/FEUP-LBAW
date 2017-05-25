<div id="uploadFile" class=" modal fade col-md-6 col-md-offset-3">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4  class="modal-title">Upload file</h4>
    </div>
    <div class="modal-body">

      <form  id ="myDropzone" action="../../actions/project/action_add_document.php" method="post" class="dropzone" enctype="multipart/form-data" >
        
        <div class="dropzone-previews form-group fallback">
              <input name="file" type="file" multiple />
              <div class="dz-progress"><span class="dz-upload" data-dz-uploadprogress></span></div>
        </div>
       </form>

   <div class="text-center form-group" >
        <input class="btn btn-success btn-xs" id="submit-all" tabindex="2" type="submit" name="upload" value="Upload" required="">
   </div>  

    </div>
  </div>
</div>
