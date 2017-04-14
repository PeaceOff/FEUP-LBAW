<?php

  include_once('../../config/init.php');
  
  if(!isset($_SESSION['username'])){
      header('Location: ../authentication/home.php');
      exit();
    }
  //echo 'Here';
  $smarty->display('common/header.tpl');
  $smarty->display('common/navbar.tpl');
  include_once($BASE_DIR . 'pages/shared/shared_leftsidebar.php');
  include_once($BASE_DIR . 'pages/profile/addProject-form.php');
?>

<script type="text/javascript" src = "../../javascript/statistics.js"></script>

<div class="container">
  <div class="page-header">
    <h2> Pending Notifications </h2>
  </div>

  <?php  include_once 'listNotifications.php' ?>

</div>

<div class="container">
  <div class="page-header">
    <h2>My Statistics </h2>
  </div>

  <?php  include_once 'listStatistics.php' ?>
</div>



<div class="container">
  <div class="page-header">
    <h2>My Projects <a data-toggle="modal" data-target="#addProject"><i class="fa fa-plus" aria-hidden="true"></i></a></h2>
  </div>

  <!-- Card -->
  <?php  include_once 'listMyProjects.php' ?>


</div>

<div class="container">
  <div class="page-header">
    <h2> My Collaborations </h2>
  </div>

  <?php  include_once 'listMyCollaborations.php' ?>

</div>

<?php
  $smarty->display('common/footer.tpl');
?>
