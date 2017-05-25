<?php

    function get_title_of_topic($idProject){
      global $conn;

	try{
      $stmt = $conn->prepare("SELECT title AS name, id,  task_id FROM topic WHERE project_id = ?");
      $stmt->execute(array($idProject));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
      return $stmt->fetchAll();
    }

    function get_posts_of_topic($idTopic){
      global $conn;

	try{
      $stmt = $conn->prepare("SELECT * FROM post WHERE topic_id = ?");
      $stmt->execute(array($idTopic));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
      return $stmt->fetchAll();
    }

    function get_forum_by_task($task_id){
        global $conn;

			try{
        $stmt = $conn->prepare("SELECT * FROM topic WHERE task_id = ?");
        $stmt->execute(array($task_id));
			}catch(Exception $e){
				error_log("DB Error:" . $e->getMessage());
			}
        return $stmt->fetchAll();
    }

    function get_comments_of_post($idPost){
      global $conn;

	try{
      $stmt = $conn->prepare("SELECT *  FROM comment WHERE post_id = ?");
      $stmt->execute(array($idPost));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
      return $stmt->fetchAll();
    }

    function add_comment($message, $post_id, $commenter){
      global $conn;

	try{
      $stmt = $conn->prepare("INSERT INTO comment (message, date, post_id, commenter) VALUES (?,CURRENT_TIMESTAMP ,?,?)");
      $stmt->execute(array($message, $post_id, $commenter));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    }

    function add_post($content, $topic_id, $poster){
      global $conn;

	try{
      $stmt = $conn->prepare("INSERT INTO post (content, date , topic_id, poster) VALUES (?,CURRENT_TIMESTAMP ,?,?)");
      $stmt->execute(array($content, $topic_id, $poster));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}

      if(!$stmt->rowCount() > 0) {
          return false;
      }
      return $conn->lastInsertId('post_id_seq');
    }

    function add_topic($title, $project_id, $task_id, $type){
      global $conn;

	try{
      $stmt = $conn->prepare("INSERT INTO topic (title, project_id, task_id, TYPE) VALUES (?,?,?,?)");
      $stmt->execute(array($title, $project_id, $task_id, $type));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    }

    function delete_topic($topic_id){
        global $conn;

	try{
        $stmt = $conn->prepare("DELETE FROM topic WHERE topic.id = ?;");
        $stmt->execute(array($topic_id));
	}catch(Exception $e){
		error_log("DB Error:" . $e->getMessage());
	}
    }
?>
