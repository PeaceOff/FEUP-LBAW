<?php
	session_start();
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	$res->deleted_success=false;
	if(isset($_SESSION['username'])){
		$username = $_SESSION['username'];
		$document_id = $_POST['document_id'];
		$project_id = $_POST['project_id'];

		if(project_manager($username,$project_id)){
			project_delete_document($document_id);
			$res->deleted_success=true;
		}
	}

	echo $res->deleted_success;

?>
