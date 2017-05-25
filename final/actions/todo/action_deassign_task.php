<?php


    include_once('../../config/init.php');
    include_once($BASE_DIR . 'database/todo.php');
    include_once($BASE_DIR . 'database/project.php');

    if(!isset($_SESSION['username'])
	    || !isset($_POST['username']) 
	    || !isset($_POST['task_id']) 
	    || !isset($_POST['project_id']) ){
        header('Location: ../../pages/authentication/home.php');
        exit();
    }


    $username_to_deassign = htmlentities($_POST['username'], ENT_QUOTES, "UTF-8");
    $task_id = htmlentities($_POST['task_id'], ENT_QUOTES, "UTF-8");
    $project_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");
    $username = $_SESSION['username'];

    if(project_manager($username, $project_id)){
        remove_assign($username_to_deassign, $task_id);
    }else if($username == $username_to_deassign && project_allowed($username_to_deassign,$project_id)){
	if(!remove_assign($username_to_deassign, $task_id)){
		http_response_code(404);
		exit();
	}
    }else {
        http_response_code(404);
        exit();
    }

    exit();
?>
