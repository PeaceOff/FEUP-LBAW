
<?php

include_once($BASE_DIR . 'database/project.php');
include_once($BASE_DIR . 'database/forum.php');

$project_id = $_GET['id'];

$collaborators = project_get_collaborators($project_id);
$forums = get_title_of_topic($project_id);

$smarty->assign('collaborators', $collaborators); 
$smarty->assign('forums', $forums); 

$smarty->display('common/rightSidebar.tpl');

?>
