{include file='common/onlineAssistance.tpl'}

<nav class="navbar navbar-inverse navbar-fixed-top ">
    <div class="container-fluid">

        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="../authentication/home.php" id="menu-toggle" >Consord</a>
        </div>

        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav navbar-right">


                <li>
                  {include file='common/notifications.tpl'}
                </li>

                <li class="active">
                  <a href="../profile/personalPage.php">

                      <span class="glyphicon glyphicon-user"></span>
                      {$name}
                  </a>
                </li>

                <li class="my_clickable"><a data-toggle="modal" data-target="#online_assistance"><span class="glyphicon glyphicon-question-sign"></span></a></li>

                <li ><a href="../../actions/authentication/action_logout.php" onclick="signOut();"><span class="glyphicon glyphicon-log-out"></span></a></li>
            </ul>
        </div>
    </div>
</nav>
