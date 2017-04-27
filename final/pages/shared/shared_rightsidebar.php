<?php

    include_once($BASE_DIR . 'database/project.php');
    include_once($BASE_DIR . 'database/forum.php');
    include_once($BASE_DIR . 'pages/forum/forum.php');

    $project_id = $_GET['project_id'];

    $collaborators = project_get_collaborators($project_id);

    $smarty->assign('managerName', project_get_id($project_id)['manager']);
    $smarty->assign('isManager', project_manager($_SESSION['username'], $project_id));
    $smarty->assign('project_id', $project_id);
    $smarty->assign('collaborators', $collaborators);
    $smarty->assign('forums', $forums);
    $smarty->display('common/rightSidebar.tpl');
?>
