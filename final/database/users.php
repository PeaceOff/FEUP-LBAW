<?php
    //user
    function user_add($username, $password, $email) {
      global $conn;
      $stmt = $conn->prepare("INSERT INTO final.user (username, email, password) VALUES (?, ?, ?)");
      $stmt->execute(array($username, $email, $password));
    }

    function user_exists($username) {
      global $conn;
      $stmt = $conn->prepare("SELECT 1 FROM final.user WHERE username = ?");
      $stmt->execute(array($username, $email, $password));
      return $stmt->rowCount() > 0;
    }

    function get_user_by_username($username) {
      global $conn;
      $stmt = $conn->prepare("SELECT username,password FROM final.user WHERE username = ?");
      $stmt->execute(array($username));
      return $stmt->fetch();
    }

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
      $stmt = $conn->prepare("SELECT * FROM folder WHERE username = ?");
      $stmt->execute(array($username));
      return $stmt->fetchAll();
    }

    function user_get_folders_populated($username){
      global $conn;
      $stmt = $conn->prepare("SELECT * FROM view_project_folder WHERE owner = ?");
      $stmt->execute(array($username));
      return $stmt->fetchAll();
    }

    function user_get_notifications($username){
      global $conn;
      $stmt = $conn->prepare("SELECT notification.description, notification.date AS time, project.name AS project_name, type, associated, notification.id as notification_id
                              FROM notification, project WHERE project_id = project.id AND notificated = ?");
      $stmt->execute(array($username));
      return $stmt->fetchAll();
    }

    function user_delete_notification($notification_id){
      global $conn;
      $stmt = $conn->prepare("DELETE FROM notification WHERE id = ? ");
      $stmt->execute(array($notification_id));
      return $stmt->rowCount() > 0;
    }

    function user_delete_all_notifications($username){
      global $conn;
      $stmt = $conn->prepare("DELETE FROM notification WHERE notificated = ? ");
      $stmt->execute(array($username));
      return $stmt->rowCount() > 0;
    }

    function user_get_statistics($username){
      global $conn;
      $stmt = $conn->prepare("SELECT * FROM statistics WHERE username = ? ");
      $stmt->execute(array($username));
      return $stmt->fetch();
    }

?>
