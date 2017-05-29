<div id="assign-category-modal" class="modal fade">
<div class="display-flex"> 
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Select Category</h4>
      </div>
      <div class="modal-body">
        <div class="list-group task-id-handler" data-task_id="">
          {foreach from=$categories item=category}
          <a class="list-group-item btn-change-task">{$category.name}</a>
          {/foreach}
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
  </div>
</div>
</div>
</div>

