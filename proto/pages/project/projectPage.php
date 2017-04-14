<?php
    include_once('../../config/init.php');
    include_once($BASE_DIR .'database/project.php');

    $project_id = $_GET['project_id'];

    if(!isset($_SESSION['username']) || !allowed_in_project($username,$project_id)){
        header('Location: ../authentication/home.php');
        exit();
      }

    $smarty->display('common/header.tpl');
    $smarty->display('common/navbar.tpl');
    $smarty->display('common/leftSidebar.tpl');
    $smarty->display('common/rightSidebar.tpl');

    include_once 'projectBody.php';
    
    $smarty->display('common/footer.tpl');
?>
