<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username'])){
        echo json_encode(array("success" => false));
		exit();
	}

	$username = $_SESSION['username'];
	$project_id = $_POST['project_id'];
    $isOwner = $_POST['isOwner'];

	$res= json_encode(array("success" => true));

	if($isOwner == "true") {

        if(!project_manager($username,$project_id))
            $res= json_encode(array("success" => false));
        else
			project_delete($project_id);
    }else{
        project_remove_collaborator($username, $project_id);
	}

	echo $res;
	exit();
?>
