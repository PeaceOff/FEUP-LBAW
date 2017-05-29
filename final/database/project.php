<?php


  function project_add($name, $description, $deadline, $managerId) {
    global $conn;
	try{
    $stmt = $conn->prepare("INSERT INTO project (name, description, deadline, manager,start) VALUES (?, ?, ?, ?, CURRENT_DATE )");
    $stmt->execute(array($name, $description, $deadline, $managerId));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
  }


  function project_edit($new_description, $project_id, $proj_deadline){
    global $conn;
	try{
    $stmt = $conn->prepare("UPDATE project SET description = ?, deadline = ? WHERE id=?");
    $stmt->execute(array($new_description, $proj_deadline, $project_id));	
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
  }

  function project_get_id($project_id){
    global $conn;
	try{
    $stmt = $conn->prepare("SELECT *  FROM project WHERE id = ?");
    $stmt->execute(array($project_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    return $stmt->fetch();
  }

  function project_get_folder($project_id, $username){
    global $conn;
	try{
    $stmt = $conn->prepare("SELECT * FROM folder, folder_project WHERE folder.id = folder_project.folder_id AND folder_project.project_id = ? AND folder.username = ?");
    $stmt->execute(array($project_id, $username));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    return $stmt->fetch();
  }


  function project_get_owned($username){
    global $conn;
	try{
    $stmt = $conn->prepare("SELECT * FROM project WHERE manager = ?");
    $stmt->execute(array($username));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    return $stmt->fetchAll();
  }

  function project_get_collabs($username){
    global $conn;
    $stmt = $conn->prepare("SELECT name, description, deadline, manager, id FROM view_project_collabs WHERE username = ?");
    $stmt->execute(array($username));
    return $stmt->fetchAll();
  }

  function project_allowed($username, $project_id){
    global $conn;
	try{
    $stmt = $conn->prepare("SELECT 1 FROM collaborates WHERE username = ? AND project_id = ?");
    $res = $stmt->execute(array($username,$project_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    return $stmt->rowCount() > 0; 
  }
 
  function project_manager($username, $project_id){
    global $conn;
	try{
    $stmt = $conn->prepare("SELECT 1 FROM project WHERE manager = ? AND id = ?");
    $stmt->execute(array($username,$project_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    return $stmt->rowCount() > 0;
  }

  function project_update_description($project_id, $description){
    global $conn;
	try{
    $stmt = $conn->prepare("UPDATE project SET description = ? WHERE id=?");
    $stmt->execute(array($description, $project_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
  }


  function project_delete($project_id) {
    global $conn;
	try{
    $stmt = $conn->prepare("DELETE FROM project WHERE id = ?");
    $stmt->execute(array($project_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    return $stmt->rowCount() > 0;
  }

  
  function project_add_collaborator($username, $project_id) {
    global $conn;
	try{
    	$stmt = $conn->prepare("INSERT INTO collaborates (username, project_id) VALUES (?, ?)");
    	$stmt->execute(array($username, $project_id));
	}catch(PDOException $e){
		error_log("DB Error:" . $e->getMessage());
		return false;
	}
	return true;
  }

  function project_remove_collaborator($username, $project_id) {
    global $conn;
	try{
    $stmt = $conn->prepare("DELETE FROM collaborates WHERE project_id = ? AND username = ?");
    $stmt->execute(array($project_id, $username));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    return $stmt->rowCount() > 0;
  }

  function project_get_collaborators($project_id) {
    global $conn;
	try{
    $stmt = $conn->prepare("SELECT username AS name FROM  collaborates WHERE project_id = ?");
    $stmt->execute(array($project_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    return $stmt->fetchAll();
  }

  
  function project_change_folder($project_id, $folder_id){
    global $conn;
	try{
    $stmt = $conn->prepare("INSERT INTO folder_project(project_id,folder_id) VALUES (?, ?)");
    $stmt->execute(array($project_id, $folder_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
  }

  function project_remove_from_folder($project_id, $folder_id){
    global $conn;
	try{
    $stmt = $conn->prepare("DELETE FROM folder_project WHERE project_id = ? AND folder_id=?");
    $stmt->execute(array($project_id, $folder_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
  }

  function project_get_old_folder($project_id, $username){
    global $conn;
	try{
    $stmt = $conn->prepare("SELECT id FROM folder, folder_project WHERE folder_id = id AND project_id = ? AND username = ?");
    $stmt->execute(array($project_id, $username));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    return $stmt->fetch();
  }


  
  function project_add_document($project_id ,$name, $description, $type, $path){
    global $conn;
	try{
    $stmt = $conn->prepare("INSERT INTO document (name, description, type, path, project_id) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute(array($name, $description, $type, $path, $project_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
  }

  function project_get_documents($project_id){
    global $conn;
	try{
    $stmt = $conn->prepare("SELECT * FROM document WHERE project_id = ?");
    $stmt->execute(array($project_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}

    return $stmt->fetchAll();
  }

  function project_delete_document($document_id){
    global $conn;
	try{
    $stmt = $conn->prepare("DELETE FROM document WHERE id = ?");
    $stmt->execute(array($document_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
  }
?>
