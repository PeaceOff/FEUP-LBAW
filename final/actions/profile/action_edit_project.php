<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username'])){
	    header('Location: ../../authentication/home.php');
	    exit();
	}

	$proj_folder = $_POST['projectFolder'];
	$proj_description = $_POST['projectDescription'];
	$proj_deadline = $_POST['deadline'];
	$proj_id = $_POST['project_id'];

	
	project_edit($proj_description,$proj_id, $proj_deadline);
	

	header('Location: ../../pages/profile/personalPage.php');
	exit();
?>
