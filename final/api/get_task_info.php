<?php

  include_once('../config/init.php');
  include_once($BASE_DIR . 'database/todo.php');

  $task_id = $_POST['task_id'];

  $task = get_task($task_id);
  
  echo json_encode($task);
?>
