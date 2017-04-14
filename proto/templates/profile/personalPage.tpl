<script type="text/javascript" src = "../../javascript/statistics.js"></script>
{include file='editProject-form.tpl'}
<div class="container">
  <div class="page-header">
    <h2> Pending Notifications </h2>
  </div>

  {foreach from=$notifications item=notification}
    <div class="notification-item col-lg-6">
      <h4 class="item-title">{$notification.title}</h4>
      <p class="item-info">{$notification.time}</p>
      <div class="notification-links pull-right">
        {if $notification.invite}
        <a><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></a><!--TODO accept invite-->
        <a><i class="fa fa-times-circle fa-2x" aria-hidden="true"></i></a><!--TODO decline invite-->
        {else}
        <a><i class="fa fa-check fa-2x" aria-hidden="true"></i>  </a> <!--Delete notification-->
        {/if}
      </div>
    </div>
  {/foreach}

</div>

<div class="container">
  <div class="page-header">
    <h2>My Statistics </h2>
  </div>

  <canvas class="chart" id="statisticsChart"></canvas>
</div>

<div class="container">
  <div class="page-header">
    <h2>My Projects <a data-toggle="modal" data-target="#addProject"><i class="fa fa-plus" aria-hidden="true"></i></a></h2>
  </div>

  {foreach from=$projects item=project}
  <a class="cardLink" href="../project/projectPage.php">
    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
      <div class="card cardhandler">
        <div class="cardheader">
          <div class="title outliner">
            {$project.title}
          </div>
        </div>
        <div class="category">
        </div>
        <div class="desc">{$project.description}</div>
      <div class="bottom">
          <a class="btn icon-link btn-primary btn-twitter btn-sm" href="" data-toggle="modal" data-target ="#editProject">
            <i class="fa fa-pencil"></i>
          </a>
          <a class="btn icon-link btn-danger btn-sm" rel="publisher" href="#">
            <i class="fa fa-trash"></i>
          </a>
        </div>
      </div>
    </div>
  </a>
  {/foreach}
</div>

<div class="container">
  <div class="page-header">
    <h2> My Collaborations </h2>
  </div>
  {foreach from=$collaborations item=collaboration}
  <a class="cardLink" href="../project/projectPage.php">
    <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
      <div class="card cardhandler">
        <div class="cardheader">
          <div class="title outliner">
            {$collaboration.title}
          </div>
        </div>
        <div class="category">
        </div>
        <div class="desc">{$collaboration.description}</div>
      <div class="bottom">
          <a class="btn icon-link btn-primary btn-twitter btn-sm" href="" data-toggle="modal" data-target ="#editProject">
            <i class="fa fa-pencil"></i>
          </a>
          <a class="btn icon-link btn-danger btn-sm" rel="publisher" href="#">
            <i class="fa fa-trash"></i>
          </a>
        </div>
      </div>
    </div>
  </a>
  {/foreach}
</div>
