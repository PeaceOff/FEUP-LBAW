<?php
include_once '../templates/header.php';
include_once '../templates/navbar.php';
include_once '../templates/login.php';
include_once '../templates/register.php';
?>

<div class="view">
    <div class="vertical-align full-bg-img text-center">
        <ul class="">
            <li>
                <h1 class="h1-responsive outliner">Join the biggest project managment community</h1></li>
            <li>
                <p><i class="fa fa-credit-card" aria-hidden="true"></i><span class="outliner"> Show some love </span><i class="fa fa-credit-card" aria-hidden="true"></i></p>
            </li>
            <li>
                <a  href="#signIn" class="btn btn-primary btn-lg" data-toggle="modal">Login</a>
                <a  href="#signUp" class="btn btn-default btn-lg" data-toggle="modal">Sign Up</a>
            </li>
          <li>
        </ul>
    </div>
</div>

<?php
include_once '../templates/footer.php';
?>
