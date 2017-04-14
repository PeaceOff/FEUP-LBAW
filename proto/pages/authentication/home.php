<?php

  include_once 'login.php';
  include_once 'register.php';
  include_once('../../config/init.php');
  $smarty->display('common/header.tpl');
  //MOVE OR STAY??
  $notifications = user_get_notifications($_SESSION['username']);
  $smarty->assign('notifications', $notifications);
  //MOVE OR STAY??
  $smarty->display('common/navbar.tpl');

?>

<div class="view">
    <div class="vertical-align full-bg-img text-center">
        <ul class="padding-0">
            <li>
                <h1 class="h1-responsive outliner">Join the biggest project managment community</h1></li>
            <li>
                <h4 class="outliner">Be the first to explore</h4>
            </li>
            <li>
                <a class="btn btn-primary btn-lg" data-toggle="modal" data-target="#signIn">Login</a>
                <a class="btn btn-default btn-lg" data-toggle="modal" data-target="#signUp">Sign Up</a>
            </li>
          <li>
        </ul>
    </div>
</div>

<?php
  $smarty->display('common/footer.tpl');
?>
