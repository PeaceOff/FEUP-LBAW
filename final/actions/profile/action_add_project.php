<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) ||
		!isset($_POST['projectName']) ||
		!isset($_POST['projectDescription']) ||
		!isset($_POST['deadline'])){
		header('Location: ../../authentication/home.php');
		exit();
	}

	$proj_name = htmlentities($_POST['projectName'], ENT_QUOTES, "UTF-8");
	$proj_description = htmlentities($_POST['projectDescription'], ENT_QUOTES, "UTF-8");
	$proj_deadline = htmlentities($_POST['deadline'], ENT_QUOTES, "UTF-8");

	project_add($proj_name,$proj_description,$proj_deadline,$_SESSION['username']);

	header('Location: ../../pages/profile/personalPage.php');
	exit();
?>
