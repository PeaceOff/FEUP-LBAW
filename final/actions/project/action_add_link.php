<?php

	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username'])
		|| !isset($_POST['project_id']) 
		|| !isset($_POST['linkName']) ){
		header('Location: ../../pages/authentication/home.php');
		exit();
	}
	$project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");
	$linkPath = htmlentities($_POST['linkName'], ENT_QUOTES, "UTF-8");


	if(!project_allowed($_SESSION['username'], $project_id)){
		header('Location: ../../pages/authentication/home.php ');
		exit();
	}

	project_add_document($project_id, '', '', 'Link', $linkPath);

	header('Location: ../../pages/project/projectPage.php?project_id=' . $project_id);
	exit();
?>
