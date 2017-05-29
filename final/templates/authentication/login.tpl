<div id="signIn" class="modal fade">
<div class="display-flex">
<div class="col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2 col-xs-12">
    <div class="modal-content modal-out">
        <div class="modal-header text-center">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4  class="modal-title">Log in</h4>
        </div>
        <div class="modal-body clearfix">

            <form id = "signIn-form" action="../../actions/authentication/action_login.php" method="post" style="display: block;" class="sign_in" login_conf="0">
                <div class="input-group form-group">
                    <span class="input-group-addon" ><i class="glyphicon glyphicon-user"></i></span>
                    <input class="form-control" type="text" placeholder="Username" tabindex = "1" name="username" value="" required="" autofocus>
                </div>
                <div class="input-group form-group">
                    <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                    <input class="form-control" type="password" placeholder="Password" tabindex = "2" name="password" value="" required="">
                </div>
                <div class="text-center">
                    <input class="btn btn-success" type="submit" name="signin"  tabindex="3" value="Sign In" >
                </div>
            </form>
            <div class="text-center">
                <h4>Login With</h4>
                <ul class="list-inline">
                    <li>
                        <a href="../../actions/authentication/sigarra/action_login.php" class="fa fa-fw fa-up fa-3x"></a>
                    </li>
                    <li>
                        <a href="../../actions/authentication/google/action_login.php" class="icon-link" > <i class="fa fa-google fa-2x" aria-hidden="true"></i>  </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
</div>
</div>
