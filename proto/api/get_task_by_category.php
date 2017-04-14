<?php
  include_once('../../config/init.php');
  include_once($BASE_DIR . 'database/todo.php');
  //include db

  $search=$_POST['search'];
  $typeId=$_POST['typeId'];


  //$results= gettaskbycategory()
  echo json_encode($results);
?>
