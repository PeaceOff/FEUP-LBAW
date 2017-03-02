<div id="signIn" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content">
    <div class="modal-header text-center">
      <h3>Log in</h3>
    </div>
      <div class="modal-body clearfix">
      <!-- Sign in-->
        <form id = "signIn-form" action="" method="post" style = "display: block;" >
          <div class="input-group form-group">
            <span class="input-group-addon" ><i class="glyphicon glyphicon-user"></i></span>
            <input class="form-control" type="text" placeholder="Username" tabindex = "1" name="username" value="" required="">
          </div>
          <div class="input-group form-group">
            <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
            <input class="form-control" type="password" placeholder="Password" tabindex = "2" name="password" value="" required="">
          </div>
          <div class="text-center">
            <input class="btn btn-success" type="submit" name="signin"  tabindex="3" value="Sign In" required="">
          </div>
      </form>
      <div class="text-center col-md-12" style = "display:block">
      <h4>Or Log in with :</h4>
        <div class="icons col-md-12 ">
            <ul class="thumbnails ">
                <li class="card card-small colorless col-lg-8 col-md-8 col-sm-10 col-xs-12">
                    <div class="card-block circle">
                        <img class="img-responsive " alt="an image" src="../assets/facebook.jpg" />
                    </div>
                </li>

                <li class="card card-small colorless col-lg-8 col-md-8 col-sm-10 col-xs-12">
                    <div class="card-block">
                        <img class="img-responsive" alt="an image" src="../assets/feup.png" />
                    </div>
                </li>

              </ul>
        </div>
      </div>
    </div>
  </div>
</div>
