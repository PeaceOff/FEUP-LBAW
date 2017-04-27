<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username'])){
		header('Location: ../../authentication/home.php');
		exit();
	}

	$username = $_SESSION['username'];
	$project_id = $_POST['project_id'];

	if(!project_manager($username,$project_id)){
		header('Location: ../../authentication/home.php');
		exit();
	}

	project_delete($project_id);

	header('Location: ../../pages/profile/personalPage.php');
	exit();
?>
