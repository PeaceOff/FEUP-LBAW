<?php
include_once '../templates/header.php';
include_once '../templates/navbar.php';
include_once '../templates/leftSidebar.php';
include_once '../templates/createTask-form.php';
?>

<div class="container center-block" >
  <h2 class="text-center page-header">Project Title - Todo Board</h2>

  <!-- Project Management -->
  <div class="container visible-xs">
    <div class="page-header" style="margin-top : 20px">
      <h3 style="margin : auto">Project Management
        <button type="button" class="btn btn-default btn-sm" data-toggle="collapse" data-target="#management" aria-expanded="false">
          <span class="sr-only">Toggle navigation</span>
          <span class="caret"></span>
        </button>
      </h3>
    </div>
    <div class="collapse" id="management">
      <ul class="nav nav-tabs">
        <li class="nav-item active">
          <a class="nav-link color-blue" href="#">Users</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">Add User</a>
        </li>
      </ul>
      <table class="table table-condensed table-style">
        <tr>
          <td>
            User A
          </td>
          <td class="align-right">
            <button href="" class="btn btn-danger btn-xs"> Remove </button>
          </td>
        </tr>
        <tr>
          <td>
            User B
          </td>
          <td class="align-right">
            <button href="" class="btn btn-danger btn-xs"> Remove </button>
          </td>
        </tr>
        <tr>
          <td>
            User C
          </td>
          <td class="align-right">
            <button href="" class="btn btn-danger btn-xs"> Remove </button>
          </td>
        </tr>
      </table>
      <div class="width-100">
        <ul class="btn-group-vertical width-100 padding-0">
          <li class="btn btn-primary" data-toggle="modal" data-target="#forum1">Forum Topic 1</li>
          <li class="btn btn-primary" data-toggle="modal" data-target="#forum1">Forum Topic 2</li>
          <li class="btn btn-primary" data-toggle="modal" data-target="#forum1">Forum Topic 3</li>
        </ul>
      </div>
      <?php include_once '../templates/forumExample.php'; ?>
    </div>
  </div>

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
        <li><a href="#">High Priority</a></li>
        <li><a href="#">Low Priority</a></li>
        <li><a href="#">Art work</a></li>
      </ul>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-toggle="modal" data-target="#createTask">+ Add Task</a>
    </li>
  </ul>
</div>
<div class="container margin-top-10">
  <div id="to-do" class="selectable">
    <?php
    include '../templates/task-card.php';
    include '../templates/project-card.php';
    include '../templates/project-card.php';
    include '../templates/project-card.php';
    include '../templates/project-card.php';
    ?>
  </div>
  <div id="doing" class="selectable">
    <?php
    include '../templates/project-card.php';
    include '../templates/project-card.php';
    include '../templates/project-card.php';
    ?>
  </div>
  <div id="done" class="selectable">
    <?php
    include '../templates/project-card.php';
    ?>
  </div>
</div>
<?php
include_once '../templates/rightSidebar.php';

include_once '../templates/footer.php';
?>
