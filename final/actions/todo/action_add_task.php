<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) 
		|| !isset($_POST['project_id'])
		|| !isset($_POST['title']) 
		|| !isset($_POST['category']) 
		|| !isset($_POST['deadline']) 
		|| !isset($_POST['description']) ){
		header('Location: ../../pages/authentication/home.php');
        	exit();
    	}

	$username = $_SESSION['username'];

	$project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");

  	if(!project_allowed($username,$project_id)){
		header('Location: ../../pages/authentication/home.php');
	    	exit();
	}
 

	$task_title = htmlentities($_POST['title'], ENT_QUOTES, "UTF-8");
	$task_category = htmlentities($_POST['category'], ENT_QUOTES, "UTF-8");
	$task_deadline = htmlentities($_POST['deadline'], ENT_QUOTES, "UTF-8");
	
	$task_deadline= new DateTime($task_deadline);
	$task_deadline = $task_deadline->format('Y-m-d H:i:s');
	$task_description =  htmlentities($_POST['description'], ENT_QUOTES, "UTF-8");

	add_task($task_title,$task_description,$task_deadline, $_SESSION['username'], $project_id ,$task_category);

	header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do.php');
	exit();
?>
