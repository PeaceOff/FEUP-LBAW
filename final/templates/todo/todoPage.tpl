{include file="todo/assignCategory-form.tpl"}
{include file="todo/assignUser-form.tpl"}
{include file="todo/addTask-form.tpl"}
{include file="todo/editTask-form.tpl"}

<div class="container center-block" >
  <a class="link-no-style" href="projectPage.php"> <h1 class="text-center "> {$project_title} </h1> </a>
  <h3 class= "text-center page-header">Todo Board</h3>
  <ul class="nav nav-tabs">
  {foreach from=$categories item=category}
    <li id="{$category.name}_button" class="nav-item ">
      <a class="nav-link toggler" href="#{$category.name}">{$category.name}</a>
    </li>
  {/foreach}
    <li class="nav-item">
      <a class="nav-link" data-toggle="modal" data-target="#createTask">+ Add Task</a>
    </li>
  </ul>
</div>
<div class="container margin-top-10">
{foreach from=$tasks_by_category item=bundle}
  <div id="{$bundle.category}" class="selectable">

    {foreach from=$bundle.tasks item=task}
    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 task-card" task_id="{$task.id}">
      <div class="card cardhandler">
        <div class="cardheader-todo">
          <div class="title outliner">
            <h5>{$task.name}</h5>
          </div>

        </div>
        <div class="desc">{$task.description}</div>
        <div class="people-envolved">
          <div class="owner">
            <h5>Owner</h5>
        	<i class="fa fa-user avatar icon-link img-circle" title="{$task.owner}" aria-hidden="true"></i>
          </div>
          <div class="collaborator">
            <h5>People Assigned</h5>
            {foreach from=$task.assigned item=assignee}
        	<i class="fa fa-user avatar icon-link img-circle" title="{$assignee.username}" aria-hidden="true"></i>
            {/foreach}
            <a class="btn icon-link btn-success btn-sm btn-assign-task-id "task_id="{$task.id}" data-toggle="modal" data-target="#assign-user-modal">
              <i class="fa fa-plus"></i>
            </a>
            <a class="btn icon-link btn-success btn-sm btn-deassign-task-id "task_id="{$task.id}">
              <i class="fa fa-minus" aria-hidden="true"></i>
            </a>
          </div>
        </div>
        <div class="bottom">
          <a class="btn icon-link btn-primary  btn-sm btn-assign-task-id btn_edit_task" task_id="{$task.id}" data-toggle="modal" data-target="#editTask">
            <i class="fa fa-pencil"></i>
          </a>
          <a class="btn icon-link btn-warning btn-sm btn-assign-task-id" task_id="{$task.id}" data-toggle="modal" data-target="#assign-category-modal">
            <i class="fa fa-arrows"></i>
          </a>
          <a class="btn icon-link btn-info btn-sm btn-assign-task-id" task_id="{$task.id}" data-toggle="modal" data-target="#forum1">
            <i class="fa fa-comments-o"></i>
          </a>
          <a class="btn icon-link btn-danger btn-sm btn-assign-task-id btn-delete-task" task_id="{$task.id}"  >
            <i class="fa fa-trash"></i>
          </a>
        </div>
      </div>
    </div>
    {/foreach}
  </div>
{/foreach}
</div>

<script id="api_tmpl" type="text/x-jsrender">{literal}
<div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 task-card" task_id="{{:id}}">
  <div class="card cardhandler">
    <div class="cardheader-todo">
      <div class="title outliner">
        <h5>{{:name}}</h5>
      </div>

    </div>
    <div class="desc">{{:description}}</div>
    <div class="people-envolved">
      <div class="owner">
        <h5>Owner</h5>
        <i class="fa fa-user avatar icon-link img-circle" title="{{:owner}}" aria-hidden="true"></i>
      </div>
      <div class="collaborator">
        <h5>People Assigned</h5>
        {{for assigned}}
        <i class="fa fa-user avatar icon-link img-circle" title="{{:username}}" aria-hidden="true"></i>
        {{/for}}
        <a class="btn icon-link btn-success btn-sm  btn-assign-task-id" task_id="{{:id}}" data-toggle="modal" data-target="#assign-user-modal">
          <i class="fa fa-plus"></i>
        </a>
      </div>
    </div>
    <div class="bottom">
      <a class="btn icon-link btn-primary  btn-sm  btn-assign-task-id btn_edit_task" task_id="{{:id}}" data-toggle="modal" data-target="#editTask">
        <i class="fa fa-pencil"></i>
      </a>
      <a class="btn icon-link btn-warning btn-sm  btn-assign-task-id" task_id="{{:id}}" data-toggle="modal" data-target="#assign-category-modal">
        <i class="fa fa-arrows"></i>
      </a>
      <a class="btn icon-link btn-info btn-sm btn-assign-task-id" task_id="{{:id}}" data-toggle="modal" data-target="#forum1">
        <i class="fa fa-comments-o"></i>
      </a>
      <a class="btn icon-link btn-danger btn-sm btn-assign-task-id btn-delete-task" task_id="{{:id}}"  >
        <i class="fa fa-trash"></i>
      </a>
    </div>
  </div>
</div>{/literal}
</script>
