<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) 
		|| !isset($_POST['task_id']) 
		|| !isset($_POST['collaborator'])
	      || !isset($_POST['project_id'])){
		header('Location: ../../pages/authentication/home.php');
        	exit();
    	}

	$username = $_SESSION['username'];
	$collaborator = htmlentities($_POST['collaborator'], ENT_QUOTES, "UTF-8");
	$project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");

  	if(!project_allowed($username,$project_id) || !project_allowed($collaborator, $project_id)){
		header('Location: ../../pages/authentication/home.php');
		http_response_code(404);
		exit();
	}
	 

	$task_category = htmlentities($_POST['category'], ENT_QUOTES, "UTF-8");
	$task_id = htmlentities($_POST['task_id'], ENT_QUOTES, "UTF-8");

	if(!add_assigned($collaborator, $task_id)){
		http_response_code(404);
		exit();	
	}
	header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do');
	exit();
?>
