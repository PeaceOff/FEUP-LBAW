<?php
  include_once('../../config/init.php');
  include_once($BASE_DIR . 'database/search.php');
  include_once($BASE_DIR . 'database/project.php');

  if(!isset($_SESSION['username'])){
      header('Location: ../pages/authentication/home.php');
      exit();
  }

  $username = $_SESSION['username'];
  $project_id = $_POST['project_id'];
  $query = $_POST['search_query'];

  if(!project_allowed($username,$project_id)){
      header('Location: ../pages/authentication/home.php');
      exit();
  }


  $res['tasks'] = search_task($query,$project_id);
  $res['topics'] = search_topic_title($query,$project_id);
  $res['posts'] = search_post_content($query,$project_id);


  echo json_encode($res);
?>
