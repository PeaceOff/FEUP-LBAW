<?php

  //project
  function project_add($name, $description, $deadline, $managerId) {
    global $conn;
    $stmt = $conn->prepare("INSERT INTO project (name, description, deadline, manager) VALUES (?, ?, ?, ?)");
    $stmt->execute(array($name, $description, $deadline, $managerId));
  }

  function project_get_owned($username){
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM project WHERE manager = ?");
    $stmt->execute(array($username));
    return $stmt->fetchAll();
  }

  function project_get_collabs($username){
    global $conn;
    $stmt = $conn->prepare("SELECT name, description, deadline, manager, id FROM view_project_collabs WHERE username = ?");
    $stmt->execute(array($username));
    return $stmt->fetchAll();
  }

  function allowed_in_project($username, $project_id){
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM project WHERE username = ? AND id = ?");
    $stmt->execute(array($username,$project_id));
    return $stmt->fetch();
  }

  function project_update_description($project_id, $description){
    global $conn;
    $stmt = $conn->prepare("UPDATE project SET description = ? WHERE id=?");
    $stmt->execute(array($description, $project_id));
  }

  function project_delete($project_id) {
    global $conn;
    $stmt = $conn->prepare("DELETE FROM project WHERE id = ?");
    $stmt->execute(array($project_id));
  }

  //collaborates
  function project_add_collaborator($username, $project_id) {
    global $conn;
    $stmt = $conn->prepare("INSERT INTO collaborates (username, project_id) VALUES (?, ?)");
    $stmt->execute(array($username, $project_id));
  }

  function project_remove_collaborator($username, $project_id) {
    global $conn;
    $stmt = $conn->prepare("DELETE FROM collaborates WHERE project_id = ? AND username = ?");
    $stmt->execute(array($project_id, $username));
  }

  //project_folder
  function project_change_folder($project_id, $folder_id){
    global $conn;
    $stmt = $conn->prepare("INSERT INTO project_folder(poject_id,folder_id) VALUES (?, ?)");
    $stmt->execute(array($project_id, $folder_id));
  }

  function project_remove_from_folder($project_id, $folder_id){
    global $conn;
    $stmt = $conn->prepare("DELETE FROM project_folder WHERE project_id = ? AND folder_id=?");
    $stmt->execute(array($project_id, $folder_id));
  }

  //document
  function project_add_document($project_id ,$name, $description, $type, $path){
    global $conn;
    $stmt = $conn->prepare("INSERT INTO document (name, description, type, path, project_id) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute(array($name, $description, $type, $path, $project_id));
  }

  function project_get_documents($project_id){
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM document WHERE project_id = ?");
    $stmt->execute(array($project_id));

    return $stmt->fetchAll();
  }

  function project_delete_document($document_id){
    global $conn;
    $stmt = $conn->prepare("DELETE FROM document WHERE id = ?");
    $stmt->execute(array($document_id));
  }
?>
