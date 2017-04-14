
<nav class="navbar navbar-inverse navbar-fixed-top ">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="../authentication/home.php" id="menu-toggle" >Consord</a>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav navbar-right">

                <li class="active">
                  <a href="../profile/personalPage.php">
                    <div>
                      <span class="float-left glyphicon glyphicon-user"></span>
                      <h6 id="login_status" class="float-right text-white"> </h6>
                    </div>
                  </a>
                </li>

                <li ><a href="#" onclick="logout()"><span class="glyphicon glyphicon-log-out"></span></a></li><!--TODO action logout-->
            </ul>
        </div>
    </div>
</nav>
