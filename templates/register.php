<div id="signUp" class="modal fade col-md-6 col-md-offset-3">
  <div class="modal-content modal-out">
    <div class="modal-header text-center">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h4 class="modal-title">Register</h4>
    </div>
      <div class="modal-body">
        <!-- Sign up-->
        <form  id ="signUp-form" action="" method="post" style="display:block">
          <div class="input-group form-group">
            <span class="input-group-addon" ><i class="glyphicon glyphicon-user"></i></span>
            <input class="form-control " type="text" tabindex="1" placeholder="Username" name="username"  required=""  autofocus="">
          </div>
          <div class="input-group form-group">
            <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
            <input class="form-control" type="password" tabindex="2" placeholder="Password" name="password" required="">
          </div>
          <div class="input-group form-group">
            <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
            <input class="form-control" type="password" tabindex="3" placeholder="Confirm password" name="confirmPassword"  required="">
          </div>
          <div class="input-group form-group">
            <span class="input-group-addon"><i class="glyphicon glyphicon-envelope"></i></span>
            <input class="form-control" type="email" tabindex="4" placeholder="email" name="email"  required="">
          </div>
          <div class=" text-center">
            <input class="btn btn-success" type="submit" tabindex="5" name="signup" value="Sign Up" required="">
          </div>
        </form>
      </div>
    </div>
  </div>
