<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');

	if(!isset($_SESSION['username']) || !isset($_POST['project_id'])){
		header('Location: ../../pages/authentication/home.php');
        	exit();
    	}

	$project_id = $_POST['project_id'];
	
	$task_id = $_POST['task_id'];
	$task_description = $_POST['description'];
	$task_category = $_POST['category'];
	$task_deadline = $_POST['deadline'];
	

	if(!isset($task_id)|| !isset($task_description) || !isset($task_category) || !isset($task_deadline)){
		header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do.php');       
	 	exit();
	}

	update_task($task_description, $task_category, $task_deadline,$task_id);


	header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do.php');
	exit();
?>
