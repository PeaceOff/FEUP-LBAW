<?php
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/forum.php');

	if(!isset($_SESSION['username'])){
           header('Location: ../authentication/home.php');
           exit();
  	}

	$topic_name = $_POST['topicName'];
	$project_id = $_POST['project_id'];

	add_topic($topic_name, $project_id, null , 'project');

	header('Location: ' . $_SERVER['HTTP_REFERER']);
	exit();
?>
