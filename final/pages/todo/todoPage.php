<?php

    include_once('../../config/init.php');
    include_once($BASE_DIR .'database/todo.php');
    include_once($BASE_DIR .'database/project.php');

    if(!isset($_SESSION['username']) || !isset($_GET['project_id'])){
        header('Location: ../authentication/home.php');
        die();
    }

    $username = $_SESSION['username'];
    if(!project_allowed($username,$_GET['project_id'])){
        header('Location:../authentication/home.php');
        die();
    }
    $smarty->display('common/header.tpl');
    include_once($BASE_DIR . 'pages/shared/shared_header.php');
    include_once($BASE_DIR . 'pages/shared/shared_leftsidebar.php');
    include_once($BASE_DIR . 'pages/shared/shared_rightsidebar.php');

    $project_id = $_GET['project_id'];


    $categories = get_categories();

    $tasks_by_category = array();

    foreach($categories as $category){

	$temp['category'] = $category['name'];
	$temp['tasks'] = array();
	array_push($tasks_by_category,$temp);
    }

    $smarty->assign('tasks_by_category', $tasks_by_category);

    $smarty->assign('categories', $categories);
    $smarty->assign('project_id', $project_id);
    $smarty->display('todo/todoPage.tpl');
    $smarty->display('common/footer.tpl');
?>
