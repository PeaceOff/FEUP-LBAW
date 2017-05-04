<?php

	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(isset($_SESSION['username'])){
		$username = $_SESSION['username'];
		$document_id = $_POST['document_id'];
		$project_id = $_POST['project_id'];
		$type_of_doc = $_POST['type_of_doc'];
		$document_path = $_POST['document_path'];

		if(project_manager($username,$project_id)){
			project_delete_document($document_id);
		}
	
		if($type_of_doc == 'Document'){		
			unlink($document_path);
		}	
	}

	header('Location: ' . $_SERVER['HTTP_REFERER']);
	exit();
?>
