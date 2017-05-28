<?php


    if(isset($_POST['email'])){

        $admin_email = "consordLBAW@gmail.com";
        $email = $_POST['email'];
        $subject = $_POST['subject'];
        $content = $_POST['content'];
        $name = $_POST['name'];

        $headers = 'From: ' .  $email . "\r\n" ;

        $msg = "From : " . $name . "\r\n" . "Mesagem : " . $content . "\r\n";

        mail($admin_email, $subject, $msg, $headers);

    }

    header("Location:" . $_SERVER['HTTP_REFERER']);
?>