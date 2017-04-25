<?php

    function get_tasks_of_project($idProject, $categoryName){
      global $conn;

      $stmt = $conn->prepare("SELECT * FROM task WHERE project_id = ? AND category = ?");
      $stmt->execute(array($idProject, $categoryName));
      return $stmt->fetchAll();
    }

    function add_task($name, $description, $deadline, $owner, $project_id, $category){
      global $conn;

      $stmt = $conn->prepare("INSERT INTO task (name, description, deadline, owner, project_id, category) VALUES (?, ?, ?, ?, ?, ?)");
      $stmt->execute(array($name, $description, $deadline, $owner, $project_id, $category));
    }

    function add_assigned($username, $task_id){
      global $conn;

      $stmt = $conn->prepare("INSERT INTO assigned VALUES (?,?)");
      $stmt->execute(array($username, $task_id));
    }


    function update_task($description, $category, $deadline,$task_id){
      global $conn;

      $stmt = $conn->prepare("UPDATE task SET (description, category, deadline) = (?,?,?) WHERE id = ?");
      $stmt->execute(array($description, $category, $deadline,$task_id));
    }

    function remove_task($task_id){
      global $conn;

      $stmt = $conn->prepare("DELETE FROM task  WHERE id = ?");
      $stmt->execute(array($task_id));
    }
?>
