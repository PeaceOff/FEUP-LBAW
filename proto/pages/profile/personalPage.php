<?php

    include_once('../../config/init.php');
    include_once($BASE_DIR . 'database/project.php');

    if(!isset($_SESSION['username'])){
      header('Location: ../authentication/home.php');
      exit();
    }

    $smarty->display('common/header.tpl');
    include_once($BASE_DIR . 'pages/shared/shared_header.php');
    include_once($BASE_DIR . 'pages/shared/shared_leftsidebar.php');

    $username = $_SESSION['username'];

    $projects = project_get_owned($username);
    $smarty->assign('projects',$projects);

    $collaborations = project_get_collabs($username);

    $username = $_SESSION['username'];
    $collabs_not_managing = array();

    foreach($collaborations as $value){
      if(strcmp($username,$value['manager']) != 0)
    	  array_push($collabs_not_managing,$value);
    }

    $folders_add = user_get_folders($_SESSION['username']);

    $smarty->assign('folders2',$folders_add);
    $smarty->assign('collaborations',$collabs_not_managing);

    $smarty->display('profile/addProject-form.tpl');
    $smarty->display('profile/editProject-form.tpl');
    $smarty->display('profile/personalPage.tpl');
    $smarty->display('common/footer.tpl');
?>
