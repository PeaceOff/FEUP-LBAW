<?php

	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	

	if(!isset($_SESSION['username'])
		|| !isset($_POST['project_id']) ){
		header('Location: ../../pages/authentication/home.php');
		exit();
	}

	$project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");
	if(!project_allowed($_SESSION['username'], $project_id)){
		header('Location: ../../pages/authentication/home.php ');
		exit();
	}

	for($i = 0; $i < sizeof($_FILES['file']['name']); $i++){
		
		$uploadDir = $BASE_DIR . '/uploads/'.$project_id. '/';
		mkdir($uploadDir);
		$uploadfile = $uploadDir . basename($_FILES['file']['name'][$i]);
		

		move_uploaded_file($_FILES['file']['tmp_name'][$i], $uploadfile);

		project_add_document($project_id, $_FILES['file']['name'][$i], 'Description' , 'Document', $uploadfile);
	}
	header('Location: ../../pages/project/projectPage.php?project_id=' . $project_id);
	exit();
?>
