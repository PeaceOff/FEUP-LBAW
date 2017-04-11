<?php
include_once '../../templates/header.php';
include_once '../../templates/navbar.php';
include_once '../../templates/leftSidebar.php';
include_once 'addTask.php';
include_once 'assign-user-modal.php';
include_once 'assign-category-modal.php';
?>

<div class="container center-block" >
  <a class="link-no-style" href="projectPage.php"> <h1 class="text-center ">  Project Title <h1> </a>
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
    include 'task-card.php';
    include 'task-card.php';
    include 'task-card.php';
    include 'task-card.php';
    include 'task-card.php';
    ?>
  </div>
  <div id="doing" class="selectable">
    <?php
    include 'task-card.php';
    include 'task-card.php';
    include 'task-card.php';
    ?>
  </div>
  <div id="done" class="selectable">
    <?php
    include 'task-card.php';
    ?>
  </div>
</div>
<?php
include_once '../../templates/rightSidebar.php';

include_once '../../templates/footer.php';
?>
