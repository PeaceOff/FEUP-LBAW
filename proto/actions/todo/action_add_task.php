<?php

	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');

	$task_title = $_POST['title'];
	$task_category = $_POST['category'];
	$task_deadline = $_POST['deadline'];
	$task_description =  $_POST['description'];

	$project_id = $_GET['project_id'];


  	add_task($task_title,$task_description,$task_deadline, $_SESSION['username'], 10 ,$task_category);

	header('Location: ../../pages/todo/todoPage.php');

?>