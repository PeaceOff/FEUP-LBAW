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

	$content = $_POST['post_content'];
	$topic_id = $_POST['forum_id'];

	add_post($content, null, $topic_id, $username);

	header('Location: ' . $_SERVER['HTTP_REFERER']);
	exit();
?>
