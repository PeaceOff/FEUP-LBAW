<?php
    include_once('../../config/init.php');

    if(isset($_SESSION['username'])){
    header('Location: ../profile/personalPage.php');
    exit();
    }
    $smarty->display('common/header.tpl');

    include_once($BASE_DIR . 'pages/shared/shared_header.php');
    $smarty->display('authentication/home.tpl');
    $smarty->display('common/footer.tpl');
?>
