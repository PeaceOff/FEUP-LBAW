<?php
  

  function addProject($name, $description, $deadline, $managerId) {
    global $conn;
    $stmt = $conn->prepare("INSERT INTO project (name, description, deadline, manager) VALUES (?, ?, ?, ?)");
    $stmt->execute(array($name, $description, $deadline, $managerId));
  }





?>
