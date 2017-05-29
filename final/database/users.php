<?php
    
    function user_add($username, $password, $email,$name) {
      global $conn;
	try{
      $stmt = $conn->prepare("INSERT INTO final.user (username, email, password,name) VALUES (?, ?, ?, ?)");
      $stmt->execute(array($username, $email, $password, $name));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    }
/*
    function user_exists($username) {
      global $conn;
	try{
      $stmt = $conn->prepare("SELECT 1 FROM final.user WHERE username = ?");
      $stmt->execute(array($username, $email, $password));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
      return $stmt->rowCount() > 0;
    }
*/
    function get_user_by_username($username) {
      global $conn;
	try{
      $stmt = $conn->prepare("SELECT username,password FROM final.user WHERE username = ?");
      $stmt->execute(array($username));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
	if($stmt->rowCount() == 0){
		error_log("DB Error:". $username ."unknown");		
	}
      return $stmt->fetch();
    }

    function user_add_folder($folder_name, $owner) {
      global $conn;
	try{
      $stmt = $conn->prepare("INSERT INTO folder (name, username) VALUES (?, ?)");
      $stmt->execute(array($folder_name, $owner));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    }

    function user_update_folder($id, $folder_name) {
      global $conn;
	try{
      $stmt = $conn->prepare("UPDATE folder SET name = ? WHERE id = ?");
      $stmt->execute(array($folder_name, $id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    }

    function user_delete_folder($id) {
      global $conn;
	try{
      $stmt = $conn->prepare("DELETE FROM folder WHERE id = ?");
      $stmt->execute(array($id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    }

    function user_get_folders($username){
      global $conn;
	try{
      $stmt = $conn->prepare("SELECT * FROM folder WHERE username = ?");
      $stmt->execute(array($username));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
      return $stmt->fetchAll();
    }

    function user_get_folders_populated($username){
      global $conn;
	try{
      $stmt = $conn->prepare("SELECT * FROM view_project_folder WHERE owner = ?");
      $stmt->execute(array($username));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
      return $stmt->fetchAll();
    }

    function user_get_notifications($username){
      global $conn;
      try{
      $stmt = $conn->prepare("SELECT notification.description, notification.date AS time, project.name AS project_name, type, associated, notification.id as notification_id FROM final.notification, final.project WHERE project_id = project.id AND notificated = ?");
      $stmt->execute(array($username));
      }catch(Exception $e){
           error_log("DB Error:" . $e->getMessage());
      }
      return $stmt->fetchAll();
    }

    function user_delete_notification($notification_id){
      global $conn;
	try{
      $stmt = $conn->prepare("DELETE FROM notification WHERE id = ? ");
      $stmt->execute(array($notification_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
      return $stmt->rowCount() > 0;
    }

    function user_delete_all_notifications($username){
      global $conn;
	try{
      $stmt = $conn->prepare("DELETE FROM notification WHERE notificated = ? ");
      $stmt->execute(array($username));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
      return $stmt->rowCount() > 0;
    }

    function user_get_statistics($username){
      global $conn;
	try{
      $stmt = $conn->prepare("SELECT * FROM statistics WHERE username = ? ");
      $stmt->execute(array($username));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
      return $stmt->fetch();
    }

    function get_email($email){
        global $conn;

        try{
            $stmt = $conn->prepare("SELECT * FROM final.user WHERE email = ? ");
            $stmt->execute(array($email));
        }catch(Exception $e){
            error_log("DB Error:" . $e->getMessage());
        }
        return $stmt->fetch();

    }

?>
