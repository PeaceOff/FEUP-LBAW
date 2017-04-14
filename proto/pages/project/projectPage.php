<?php
    include_once('../../config/init.php');
    include_once($BASE_DIR .'database/project.php');

    $project_id = $_GET['project_id'];
         

    if(!isset($_SESSION['username'])){ 
        header('Location: ../authentication/home.php');
        exit();
    }
    $username = $_SESSION['username'];
    
    if(project_allowed($username,$project_id)){
    	header('Location:../authentication/home.php');
	exit();	
    }

    $smarty->display('common/header.tpl');
    $smarty->display('common/navbar.tpl');
    include_once($BASE_DIR .'pages/shared/shared_leftsidebar.php');
    $smarty->display('common/rightSidebar.tpl');

    include_once 'projectBody.php';
    
    $smarty->display('common/footer.tpl');
?>
