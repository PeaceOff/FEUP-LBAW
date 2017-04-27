<?php
    include_once('../../config/init.php');
    include_once($BASE_DIR . 'database/forum.php');
    include_once($BASE_DIR . 'database/project.php');

    if(!isset($_SESSION['username']) || !isset($_POST['project_id'])){
        header('Location: ../../pages/authentication/home.php');
        exit();
    }

    $username = $_SESSION['username'];

    $project_id = $_POST['project_id'];

    if(!project_manager($username,$project_id)){
        header('Location: ../../pages/authentication/home.php');
        exit();
    }

    $topic_id = $_POST['topic_id'];

    delete_topic($topic_id);

    header('Location: ' . $_SERVER['HTTP_REFERER']);
    exit();
?>