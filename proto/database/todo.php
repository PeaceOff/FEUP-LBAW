<?php

function getTasksOfProject($idProject, $categoryName){
  global $conn;

  $stmt = $conn->prepare("SELECT * FROM task WHERE project_id = ? AND category = ?");
  $stmt->execute(array($idProject, $categoryName));
  return $stmt->fetchAll();
}

function addTask($name, $description, $deadline, $owner, $project_id, $category){
  global $conn;

  $stmt = $conn->prepare("INSERT INTO task (name, description, deadline, owner, project_id, category) VALUES (?, ?, ?, ?, ?, ?)");
  $stmt->execute(array($name, $description, $deadline, $owner, $project_id, $category));

}


function addAssigned($username, $task_id){
  global $conn;

  $stmt = $conn->prepare("INSERT INTO assigned VALUES (?,?)");
  $stmt->execute(array($username, $task_id));

}


function updateTask($description, $category, $deadline,$task_id){
  global $conn;

  $stmt = $conn->prepare("UPDATE task SET (description, category, deadline) = (?,?,?) WHERE id = ?");
  $stmt->execute(array($description, $category, $deadline,$task_id));

}

function removeTask($task_id){
  global $conn;

  $stmt = $conn->prepare("DELETE FROM task  WHERE id = ?");
  $stmt->execute(array($task_id));

}

?>
