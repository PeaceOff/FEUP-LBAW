<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) 
		|| !isset($_POST['project_id']) 
		|| !isset($_POST['task_id'])){
		header('Location: ../../pages/authentication/home.php');
		http_response_code(401);
        	exit();
    	}

	$username = $_SESSION['username'];
	$project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");

  	if(!project_allowed($username,$project_id) ){
		header('Location: ../../pages/authentication/home.php');
		http_response_code(401);
		exit();
	}
	 
	$task_id = htmlentities($_POST['task_id'], ENT_QUOTES, "UTF-8");

	remove_task($task_id);	

	header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do.php');
	exit();
?>
