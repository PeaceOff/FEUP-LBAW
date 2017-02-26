<?php
  include_once '../templates/header.php'
 ?>

<div class="container" >
    <div class="row">
      <div class="col-md-6 col-md-offset-3"  style = "border-style: groove">

        <!-- head -->
        <div class="panel-heading">
          <div class="row text-center">
            <div class="col-xs-6 tabs">
              <a href="#"  class = "active" id = "signInLink" >Sign In</a>
            </div>
            <div class="col-xs-6 tabs" >
              <a href="#"  id = "signUpLink" >Sign Up</a>
            </div>
          </div>
        </div>

        <div class="panel-body">
          <div class="row ">
            <div class="col-lg-12 " >

              <?php
                include_once '../templates/register.php';
                include_once '../templates/login.php';
               ?>

            </div>
          </div>
      </div>
    </div>
  </div>
</div>

<?php
  include_once '../templates/footer.php'
?>
