<?php
	session_start();
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/todo.php');

	if(!isset($_SESSION['username'])){
        header('Location: ../authentication/home.php');
        exit();
    }

	$task_title = $_POST['title'];
	$task_category = $_POST['category'];
	$task_deadline = $_POST['deadline'];
	$task_description =  $_POST['description'];

	$project_id = $_GET['project_id'];

	add_task($task_title,$task_description,$task_deadline, $_SESSION['username'], $project_id ,$task_category);

	header('Location: ../../pages/todo/todoPage.php');
	exit();
?>
