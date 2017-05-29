<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) 
		|| !isset($_POST['project_id'])){
		header('Location: ../../pages/authentication/home.php');
        	exit();
		
    	}

	$username = $_SESSION['username'];

	$project_id = $_POST['project_id'];

  	if(!project_allowed($username,$project_id)){
		header('Location: ../../pages/authentication/home.php');
	    	exit();
	}

	if(!isset($_POST['task_id'])|| !isset($_POST['description']) || !isset($_POST['category']) || !isset($_POST['deadline'])){
		header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do.php');       
	 	exit();
	}

	$task_id = htmlentities($_POST['task_id'], ENT_QUOTES, "UTF-8");
	$task_description = htmlentities($_POST['description'], ENT_QUOTES, "UTF-8");
	$task_category = htmlentities($_POST['category'], ENT_QUOTES, "UTF-8");
	$task_deadline = htmlentities($_POST['deadline'], ENT_QUOTES, "UTF-8");


	update_task($task_description, $task_category, $task_deadline,$task_id);


	header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#' . $task_category);
	exit();
?>
