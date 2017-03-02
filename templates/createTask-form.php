<div id="createTask" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">New Task</h4>
    </div>
      <div class="modal-body">

        <form  id ="createTask-form" class="form-inline" action="" method="post" style="display:block">
          <div class="input-group form-group">
            <label>Task Title</label>
            <input class="form-control" type="text" tabindex="1" placeholder="Title" name="title"  required="" autofocus="">
          </div>
          <div class="form-group input-group">
            <label for="sel1">Category</label>
            <select class="form-control" id="sel1" tabindex="2">
              <option>High Priority</option>
              <option>Low Priority</option>
              <option>Artwork</option>
            </select>
          </div>
          <div class="form-group input-group ">
            <label>Deadline</label>
            <input type='text' class="form-control form-date" tabindex="3"> <!-- Add datetime bootstrap-->
          </div>
          <div class="form-group input-group width-100">
            <label for="descriptionArea">Description</label>
            <textarea class="form-control resizable-horizontal" id="descriptionArea" rows="3" tabindex="4"></textarea>
          </div>
          <div class="text-center">
            <input class="btn btn-success " type="submit" name="createTask" value="Save" required="" tabindex="5">
          </div>
        </form>
      </div>
    </div>
  </div>
