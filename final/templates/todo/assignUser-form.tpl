<div id="assign-user-modal" class="modal fade">
<div class="display-flex"> 
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Assign User</h4>
      </div>
      <div class="modal-body">
        <div class="list-group task-id-handler" data-task_id="">
          {foreach from=$collaborators item=collaborator}
          <a class="list-group-item assignUser my_clickable" >{$collaborator.name}</a>
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

