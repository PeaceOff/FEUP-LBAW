<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username'])
		|| !isset($_POST['project_id']) 
		|| !isset($_POST['isOwner']) ){
        echo json_encode(array("success" => false));
		exit();
	}

	$username = $_SESSION['username'];
	$project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");
    $isOwner = htmlentities($_POST['isOwner'], ENT_QUOTES, "UTF-8");


	if($isOwner == "true") {

		if(!project_manager($username,$project_id)){
			http_response_code(400);
			exit();
		}else if(!project_delete($project_id)){
			http_response_code(400);
			exit();
		}
    }else{
	    if(!project_remove_collaborator($username, $project_id)){
	    	http_response_code(400);
		exit();
	    }
	}
	exit();
?>
