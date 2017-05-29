<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) 
		|| !isset($_POST['task_id']) 
		|| !isset($_POST['category'])
	      || !isset($_POST['project_id'])){
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
	 

	$task_category = htmlentities($_POST['category'], ENT_QUOTES, "UTF-8");
	$task_id = htmlentities($_POST['task_id'], ENT_QUOTES, "UTF-8");

	$old_categ = get_task($task_id)['category'];

	if($old_categ == $task_category){
		http_response_code(401);
		exit();
	}


	if(!update_task_category($task_category, $task_id)){
		http_response_code(401);
		exit();
	}	

	header('Location: ../../pages/todo/todoPage.php?project_id='. $project_id .'#To-Do.php');
	exit();
?>
