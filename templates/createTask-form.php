<div id="createTask" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content">
      <button type="button" class="close" data-dismiss="modal">&times;</button>
    <div class="modal-header text-center">
      <h4 class="modal-title">New Task</h4>
    </div>
      <div class="modal-body">
        <!-- Sign up-->
        <form  id ="createTask-form" class="form-inline" action="" method="post" style="display:block">
          <div class="input-group form-group">
            <label>Task Title</label>
            <input class="form-control" type="text" tabindex="1" placeholder="Title" name="title"  required="" >
          </div>
          <div class="form-group input-group">
            <label for="sel1">Category</label>
            <select class="form-control" id="sel1">
              <option>High Priority</option>
              <option>Low Priority</option>
              <option>Artwork</option>
            </select>
          </div>
          <div class="form-group input-group ">
            <label>Deadline</label>
            <input type='text' class="form-control form-date"/> <!-- Add datetime bootstrap-->
          </div>
          <div class="input-group form-group width-100">
            <label for="descriptionArea">Description</label>
            <textarea class="form-control resizable-horizontal" id="descriptionArea" rows="3"></textarea>
          </div>
          <div class="text-center">
            <input class="btn btn-success" type="submit" tabindex="3" name="createTask" value="Save" required="">
          </div>
        </form>
      </div>
    </div>
  </div>
