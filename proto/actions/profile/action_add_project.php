<?php

	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');
	
	$proj_name = $_POST['projectName'];
	$proj_folder = $_POST['projectFolder'];
	$proj_description = $_POST['projectDescription'];
	$proj_deadline = '2016-05-13';


	
	project_add($proj_name,$proj_description,$proj_deadline,$_SESSION['username']);

	
       
	header('Location: ../../pages/profile/personalPage.php');


?>
