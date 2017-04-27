<?php
  include_once('../config/init.php');
  include_once($BASE_DIR . 'database/todo.php');

  $category = $_POST['category'];
  $project_id = $_POST['project_id'];

  $results = get_tasks_of_project_by_category($project_id, $category);
  foreach($results as &$task){
  	$task['assigned'] = get_assigned($task['id']);
  }
  echo json_encode($results);
?>
