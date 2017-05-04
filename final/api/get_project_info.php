<?php

  include_once('../config/init.php');
  include_once($BASE_DIR . 'database/project.php');

  $username = $_SESSION['username'];

  $project_id = $_POST['project_id'];

  $project = project_get_id($project_id);

  $project['folder'] = project_get_folder($project_id, $username);
   
  echo json_encode($project);
?>
