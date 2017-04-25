<?php

  include_once('../../config/init.php');
  include_once($BASE_DIR .'database/todo.php');

  $smarty->display('common/header.tpl');
  include_once($BASE_DIR . 'pages/shared/shared_header.php');
  include_once($BASE_DIR . 'pages/shared/shared_leftsidebar.php');
  include_once($BASE_DIR . 'pages/shared/shared_rightsidebar.php');

  if(!isset($_SESSION['username'])){
      header('Location: ../authentication/home.php');
      exit();
  }

  $username = $_SESSION['username'];

  if(!project_allowed($username,$_GET['project_id'])){
     header('Location:../authentication/home.php');
     exit();
  }

  $tasks = get_tasks_of_project(1, todo);

  $smarty->display('todo/todoPage.tpl');
  $smarty->display('common/footer.tpl');
?>
