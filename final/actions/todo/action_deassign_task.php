<?php


    include_once('../../config/init.php');
    include_once($BASE_DIR . 'database/todo.php');
    include_once($BASE_DIR . 'database/project.php');

    if(!isset($_SESSION['username'])){
        header('Location: ../../pages/authentication/home.php');
        exit();
    }


    $username_to_deassign = $_POST['username'];
    $task_id = $_POST['task_id'];
    $project_id = $_POST['project_id'];
    $username = $_SESSION['username'];

    if(project_manager($username, $project_id)){
        remove_assign($username_to_deassign, $task_id);
    }else if($username == $username_to_deassign && project_allowed($username_to_deassign,$project_id)){
        remove_assign($username_to_deassign, $task_id);
    }else {
        http_response_code(404);
        exit();
    }

    exit();
?>