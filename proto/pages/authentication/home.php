<?php

  include_once 'login.php';
  include_once 'register.php';
  include_once('../../config/init.php');
  $smarty->display('common/header.tpl');

// test for the notification display
  $notification1['title'] = "David Azevedo Invited you to join LBAW-A3";
  $notification1['time'] = "27-02-2017, one day ago";
  $notification1['invite'] = true;

  $notification2['title'] = "Marcelo Ferreira assigned you to a task on LBAW-A2";
  $notification2['time'] = "27-02-2017, two day ago";
  $notification2['invite'] = false;


  $notifications = array($notification1,$notification2);
  $smarty->assign('notifications',$notifications);
//

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
