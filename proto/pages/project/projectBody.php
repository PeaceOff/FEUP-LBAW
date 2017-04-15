<?php

include_once($BASE_DIR . 'database/project.php');
include_once($BASE_DIR . 'database/forum.php');


echo 'batatas:  ' . $project_id;
$project_id = $_GET['id'];
echo 'batatas:  ' . $project_id;

$project = project_get_id($project_id);
$allDocs = project_get_documents($project_id);

$links = array();
$documents = array();

foreach($allDocs as $document){
	if($document['type']=='Link')
		array_push($links, $document);
	else
		array_push($documents, $document);
}

$smarty->assign('project_id', $project_id); 
$smarty->assign('project', $project); 
$smarty->assign('links', $links); 
$smarty->assign('documents', $documents); 


$smarty->display('project/projectBody.tpl');

?>
