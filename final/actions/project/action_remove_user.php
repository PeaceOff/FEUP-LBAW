<?php

	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username'])
		|| !isset($_POST['username'])
		|| !isset($_POST['project_id']) ) {
		header('Location: ../../pages/authentication/home.php');
		exit();
	}

	$project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");
	$username = htmlentities($_POST['username'], ENT_QUOTES, "UTF-8");


	if(!project_manager($_SESSION['username'], $project_id)){
		header('Location: ../../pages/authentication/home.php ');
		exit();
	}

	project_remove_collaborator($username, $project_id);

	header('Location: ../../pages/project/projectPage.php?project_id=' . $project_id);
	exit();
?>
