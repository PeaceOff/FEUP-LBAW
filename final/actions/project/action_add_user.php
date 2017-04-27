<?php

	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) || !isset($_POST['project_id']) || !isset($_POST['username'])){
		header('Location: ../../pages/authentication/home.php');
		http_response_code(401);
		exit();
	}

	$project_id = $_POST['project_id'];
	$username = $_POST['username'];


	if(!project_manager($_SESSION['username'], $project_id)){
		header('Location: ../../pages/authentication/home.php ');
		http_response_code(401);
		exit();
	}

	if(!project_add_collaborator($username, $project_id)){
		http_response_code(401);
		exit();
	}
	
	header('Location: ' . $_SERVER['HTTP_REFERER']);
	exit();
?>
