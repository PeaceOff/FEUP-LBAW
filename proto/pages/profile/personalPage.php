<?php

  include_once('../../config/init.php');
  
  if(!isset($_SESSION['username'])){
      header('Location: ../authentication/home.php');
      exit();
    }
 
  $smarty->display('common/header.tpl');
  include_once($BASE_DIR . 'pages/shared/shared_header.php');
  include_once($BASE_DIR . 'pages/shared/shared_leftsidebar.php');
  include_once($BASE_DIR . 'pages/profile/addProject-form.php');
  include_once($BASE_DIR . 'database/project.php');
?>

<script type="text/javascript" src = "../../javascript/statistics.js"></script>

<?php
  $username = $_SESSION['username'];

  $projects = project_get_owned($username);
  $smarty->assign('projects',$projects);


  $collaborations = project_get_collabs($username);
  $smarty->assign('collaborations',$collaborations); 

  $smarty->display('profile/personalPage.tpl');

 /*

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
 */
?>

<?php
  $smarty->display('common/footer.tpl');
?>
