<?php
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/forum.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) 
		|| !isset($_POST['project_id']) 
		|| !isset($_POST['topicName'])){
		header('Location: ../../pages/authentication/home.php');
		exit();
	}

	$username = htmlentities($_SESSION['username'], ENT_QUOTES, "UTF-8");

	$project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");

	if(!project_allowed($username,$project_id)){
		header('Location: ../../pages/authentication/home.php');
		exit();
	}

	$topic_name = htmlentities($_POST['topicName'], ENT_QUOTES, "UTF-8");

	add_topic($topic_name, $project_id, null , 'project');

	header('Location: ' . $_SERVER['HTTP_REFERER']);
	exit();
?>
