<?php

	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(isset($_SESSION['username'])
		|| !isset($_POST['document_id'])
		|| !isset($_POST['project_id']) 
		|| !isset($_POST['type_of_doc']) 
		|| !isset($_POST['document_path'])){

		$username = $_SESSION['username'];
		$document_id = htmlentities($_POST['document_id'], ENT_QUOTES, "UTF-8");
		$project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");
		$type_of_doc = htmlentities($_POST['type_of_doc'], ENT_QUOTES, "UTF-8");
		$document_path = htmlentities($_POST['document_path'], ENT_QUOTES, "UTF-8");

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
