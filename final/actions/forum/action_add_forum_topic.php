<?php
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/forum.php');
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

	$topic_name = $_POST['topicName'];

	add_topic($topic_name, $project_id, null , 'project');

	header('Location: ' . $_SERVER['HTTP_REFERER']);
	exit();
?>
