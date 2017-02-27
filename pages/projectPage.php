<?php
include_once '../templates/header.php';
?>
  <button type="button" class="visible-xs hide-actor" target="sidebar-left">Left</button>
  <button type="button" class="visible-xs hide-actor" target="sidebar-right">Right</button>

  <div class="container-fluid content-relative padding-0">

    <?php
    include_once '../templates/leftSidebar.php';
    include_once '../templates/projectBody.php';
    include_once '../templates/rightSidebar.php';
    ?>

  </div>
</body>

<?php
include_once '../templates/footer.php';
?>
