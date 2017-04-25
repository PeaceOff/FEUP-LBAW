<?php
    session_start();
    include_once('../../config/init.php');

    session_destroy();
    header("Location: " . '../../pages/authentication/home.php');
    exit();
?>
