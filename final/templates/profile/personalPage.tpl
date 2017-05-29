<script type="text/javascript" src = "../../javascript/statistics.js"></script>
<div class="container">
  <div class="page-header">
    <h2> Pending Notifications </h2>
  </div>
</div>
 <div class="notification-container container">
  {foreach from=$notifications item=notification}
      <div class=" col-lg-4 col-md-4 col-sm-12 col-xs-12">
        <div class="notification-item" data-notification_id="{$notification.id}">
              <h4 class="item-title">{$notification.description}</h4>
              <p class="item-info">{$notification.time}</p>
              <div class="notification-links notification-mark  pull-right">
                  <a class="btn_delete_notification" data-notification_id="{$notification.id}"><i class="fa fa-check fa-2x"   aria-hidden="true"></i>  </a>
              </div>
          </div>
      </div>
  {/foreach}
</div>

<div class="container">
  <div class="page-header">
    <h2>My Statistics </h2>
  </div>

  <canvas id="statisticsChart" ></canvas>
</div>

<div class="container">
  <div class="page-header">
    <h2>My Projects <a data-toggle="modal" data-target="#addProject"><i class="fa fa-plus my_clickable" aria-hidden="true"></i></a></h2>
  </div>

  {foreach from=$projects item=project}
    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
      <div class="card cardhandler">
        <a class="cardLink" href='../project/projectPage.php?project_id={$project.id}'>
        <div class="cardheader">
          <div class="title outliner">
            {$project.name}
          </div>
        </div>
        <div class="category">
        </div>
        </a>
  <div class="desc">{$project.description}</div>
      <div class="bottom">
	  <input type="hidden" class="project_id" value='{$project.id}'>
          <a class="btn icon-link btn-primary btn-twitter btn-sm  btn_project_edit" data-project_id="{$project.id}" href="" data-toggle="modal" data-target ="#editProject">
            <i class="fa fa-pencil"></i>
          </a>
          <a class="btn icon-link btn-danger btn-sm link_deleteProject" rel="publisher" >
            <i class="fa fa-trash"></i>
          </a>
        </div>
      </div>
    </div>
  {/foreach}
</div>

<div class="container">
  <div class="page-header">
    <h2> My Collaborations </h2>
  </div>
  {foreach from=$collaborations item=collaboration}
    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
      <div class="card cardhandler">
        <a class="cardLink" href="../project/projectPage.php?project_id={$collaboration.id}">
        <div class="cardheader">
          <div class="title outliner">
            {$collaboration.name}
          </div>
        </div>
        <div class="category">
        </div>
        </a>
        <div class="desc">{$collaboration.description}</div>
      <div class="bottom">
          <input type="hidden" class="project_id" value='{$collaboration.id}'>
          <a class="btn icon-link btn-primary btn-twitter btn-sm  btn_collaboration_edit" href="" data-collaboration_id="{$collaboration.id}" data-toggle="modal" data-target ="#editCollaboration">
            <i class="fa fa-pencil"></i>
          </a>
          <a class="btn icon-link btn-danger btn-sm link_deleteCollaboration" rel="publisher" >
            <i class="fa fa-trash"></i>
          </a>
        </div>
      </div>
    </div>
  {/foreach}
</div>
