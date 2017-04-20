<?php
  include_once('../../config/init.php');
  include_once($BASE_DIR . 'database/todo.php');

  $category =$_POST['category'];
  $project_id =$_POST['project_id'];


  $results= get_task_of_project($project_id, $category);
  echo json_encode($results);
?>
