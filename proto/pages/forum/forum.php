<?php
    include_once('../../config/init.php');
    include_once($BASE_DIR .'database/project.php');


    if(!isset($_SESSION['username'])){
        header('Location: ../authentication/home.php');
        exit();
    }

    $username = $_SESSION['username'];

    if(!project_allowed($username,$_GET['project_id'])){
       header('Location:../authentication/home.php');
       exit;
    }

    //TODO fazer set das variaveis
?>
