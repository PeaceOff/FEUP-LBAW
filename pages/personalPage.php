<?php
include_once '../templates/header.php';
include_once '../templates/navbar.php';
include_once '../templates/leftSidebar.php';
include_once '../templates/addProject-form.php';
?>


<div class="container">
  <div class="page-header">
    <h2> Pending Notifications </h2>
  </div>

  <div class="notification-item col-sm-6">
    <h4 class="item-title">David Azevedo Invited you to join LBAW-A3</h4>
    <p class="item-info">27-02-2017, one day ago</p>
    <div class="notification-links pull-right">
      <a><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></a>
      <a><i class="fa fa-times-circle fa-2x" aria-hidden="true"></i></a>
    </div>
  </div>


  <div class="notification-item col-sm-6">
    <h4 class="item-title">David Azevedo Invited you to join LBAW-A3</h4>
    <p class="item-info">27-02-2017, one day ago</p>
    <div class="notification-links pull-right">
      <a><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></a>
      <a><i class="fa fa-times-circle fa-2x" aria-hidden="true"></i></a>
    </div>
  </div>

</div>


<div class="container">
  <div class="page-header">
    <h2>My Projects <a data-toggle="modal" data-target="#addProject"><i class="fa fa-plus" aria-hidden="true"></i></a></h2>
  </div>

  <!-- Card -->

  <a class="cardLink" href="projectPage.php">
    <?php include '../templates/project-card.php';?>
  </a>

  <a class="cardLink" href="projectPage.php">
    <?php include '../templates/project-card.php';?>
  </a>

  <a class="cardLink" href="projectPage.php">
    <?php include '../templates/project-card.php';?>
  </a>

  <a class="cardLink" href="projectPage.php">
    <?php include '../templates/project-card.php';?>
  </a>

  <a class="cardLink" href="projectPage.php">
    <?php include '../templates/project-card.php';?>
  </a>


</div>

<div class="container">
  <div class="page-header">
    <h2> My Collaborations </h2>
  </div>

  <a class="cardLink" href="projectPage.php">
    <?php include '../templates/project-card.php';?>
  </a>
</div>

<?php
include_once '../templates/footer.php';
?>
