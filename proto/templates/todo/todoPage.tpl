<div class="container center-block" >
  <a class="link-no-style" href="projectPage.php"> <h1 class="text-center "> {$project_title} </h1> </a>
  <h3 class= "text-center page-header">Todo Board</h3>
  <ul class="nav nav-tabs">
    <li class="nav-item active">
      <a class="nav-link toggler" href="#to-do">To Do</a>
    </li>
    <li class="nav-item">
      <a class="nav-link toggler"  href="#doing">Doing</a>
    </li>
    <li class="nav-item">
      <a class="nav-link toggler" href="#done">Done</a>
    </li>
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" data-toggle="dropdown"
      href="#" role="button" aria-haspopup="true" aria-expanded="false">
      Category</a>
      <ul class="dropdown-menu">
        {foreach from=$categories item=category}
        <li><a href="#">{$category.name}</a></li>
        {/foreach}
      </ul>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-toggle="modal" data-target="#createTask">+ Add Task</a>
    </li>
  </ul>
</div>
<div class="container margin-top-10">
  <div id="to-do" class="selectable">

    {foreach from=$tasks item=task}
    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
      <div class="card cardhandler">
        <div class="cardheader-todo">
          <div class="title outliner">
            {$task.title}
            <h5>Category</h5>
          </div>

        </div>
        <div class="desc">{$task.description}</div>
        <div class="people-envolved">
          <div class="owner">
            <h5>Owner</h5>
            <img class="avatar  icon-link img-circle" src="{$task.owner_img}" alt="avatar">
          </div>
          <div class="collaborator">
            <h5>People Assigned</h5>
            {foreach from=$task.assigned item=assignee}
            <img class="avatar  icon-link img-circle" src="{$assignee.img}" alt="avatar">
            {/foreach}
            <a class="btn icon-link btn-success btn-sm" data-toggle="modal" data-target="#assign-user-modal">
              <i class="fa fa-plus"></i>
            </a>
          </div>
        </div>
        <div class="bottom">
          <a class="btn icon-link btn-primary  btn-sm" >
            <i class="fa fa-pencil"></i>
          </a>
          <a class="btn icon-link btn-warning btn-sm"  data-toggle="modal" data-target="#assign-category-modal">
            <i class="fa fa-arrows"></i>
          </a>
          <a class="btn icon-link btn-info btn-sm" data-toggle="modal" data-target="#forum1">
            <i class="fa fa-comments-o"></i>
          </a>
          <a class="btn icon-link btn-danger btn-sm"  >
            <i class="fa fa-trash"></i>
          </a>
        </div>
      </div>
    </div>
    {/foreach}
  </div>
  <div id="doing" class="selectable">
  </div>

  <div id="done" class="selectable">
  </div>
</div>
