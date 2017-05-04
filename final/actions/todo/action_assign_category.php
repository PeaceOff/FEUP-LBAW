<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) || !isset($_POST['task_id']) || !isset($_POST['category'])  ){
		header('Location: ../../pages/authentication/home.php');
		http_response_code(401);
        	exit();
    	}

	$username = $_SESSION['username'];
	$project_id = $_POST['project_id'];

  	if(!project_allowed($username,$project_id) ){
		header('Location: ../../pages/authentication/home.php');
		http_response_code(401);
		exit();
	}
	 

	$task_category = $_POST['category'];
	$task_id = $_POST['task_id'];

	update_task_category($task_category, $task_id);	

	header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do.php');
	exit();
?>
