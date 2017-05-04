<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) || !isset($_POST['task_id']) || !isset($_POST['collaborator'])  ){
		header('Location: ../../pages/authentication/home.php');
        	exit();
    	}

	$username = $_SESSION['username'];
	$collaborator = $_POST['collaborator'];
	$project_id = $_POST['project_id'];

  	if(!project_allowed($username,$project_id) || !project_allowed($collaborator, $project_id)){
		header('Location: ../../pages/authentication/home.php');
		http_response_code(404);
		exit();
	}
	 

	$task_category = $_POST['category'];
	$task_id = $_POST['task_id'];

	add_assigned($collaborator, $task_id);	

	header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do');
	exit();
?>
