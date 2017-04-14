<?php


//user
function user_add($username, $password, $email) {
  global $conn;
  $stmt = $conn->prepare("INSERT INTO proto.user (username, email, password) VALUES (?, ?, ?)");
  $stmt->execute(array($username, $email, $password));
}

//folder
function user_add_folder($folder_name, $owner) {
  global $conn;
  $stmt = $conn->prepare("INSERT INTO folder (name, username) VALUES (?, ?)");
  $stmt->execute(array($folder_name, $owner));
}

function user_update_folder($id, $folder_name) {
  global $conn;
  $stmt = $conn->prepare("UPDATE folder SET name = ? WHERE id = ?");
  $stmt->execute(array($folder_name, $id));
}

function user_delete_folder($id) {
  global $conn;
  $stmt = $conn->prepare("DELETE FROM folder WHERE id = ?");
  $stmt->execute(array($id));
}

function user_get_folders($username){
  global $conn;
  $stmt = $conn->prepare("SELECT * FROM view_project_folder WHERE owner = ?");
  $stmt->execute(array($username));
  return $stmt->fetchAll();
}

?>
