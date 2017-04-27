<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) || !isset($_POST['project_id'])){
		header('Location: ../../pages/authentication/home.php');
        	exit();
    	}

	$username = $_SESSION['username'];

	$project_id = $_POST['project_id'];

  	if(!project_allowed($username,$project_id)){
		header('Location: ../../pages/authentication/home.php');
	    	exit();
	}
 

	$task_title = $_POST['title'];
	$task_category = $_POST['category'];
	$task_deadline = $_POST['deadline'];
	
	$task_deadline= new DateTime($task_deadline);
	$task_deadline = $task_deadline->format('Y-m-d H:i:s');
	$task_description =  $_POST['description'];

	add_task($task_title,$task_description,$task_deadline, $_SESSION['username'], $project_id ,$task_category);

	header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do.php');
	exit();
?>
