<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username'])){
		header('Location: ../../authentication/home.php');
		exit();
	}

	$proj_name = $_POST['projectName'];
	$proj_description = $_POST['projectDescription'];
	$proj_deadline = $_POST['deadline'];

	project_add($proj_name,$proj_description,$proj_deadline,$_SESSION['username']);

	header('Location: ../../pages/profile/personalPage.php');
	exit();
?>
