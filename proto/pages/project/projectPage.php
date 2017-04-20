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
	   exit();
    }

    $smarty->display('common/header.tpl');
    include_once($BASE_DIR . 'pages/shared/shared_header.php');
    include_once($BASE_DIR . 'pages/shared/shared_leftsidebar.php');
    include_once($BASE_DIR . 'pages/shared/shared_rightsidebar.php');

    $project = project_get_id($_GET['project_id']);

    $allDocs = project_get_documents($project['id']);

    $links = array();
    $documents = array();

    foreach($allDocs as $document){
	if($document['type']=='Link')
		array_push($links, $document);
	else
		array_push($documents, $document);
    }

    $smarty->assign('project', $project);
    $smarty->assign('links', $links);
    $smarty->assign('documents', $documents);

    $smarty->display('project/projectBody.tpl');
    $smarty->display('common/footer.tpl');
?>
