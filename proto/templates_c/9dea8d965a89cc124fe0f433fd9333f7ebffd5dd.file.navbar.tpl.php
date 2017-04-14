<?php /* Smarty version Smarty-3.1.15, created on 2017-04-14 20:21:13
         compiled from "..\..\templates\common\navbar.tpl" */ ?>
<?php /*%%SmartyHeaderCode:1719358f0afed1b3638-45320910%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '9dea8d965a89cc124fe0f433fd9333f7ebffd5dd' => 
    array (
      0 => '..\\..\\templates\\common\\navbar.tpl',
      1 => 1492193948,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '1719358f0afed1b3638-45320910',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.15',
  'unifunc' => 'content_58f0afed1c0899_03225062',
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_58f0afed1c0899_03225062')) {function content_58f0afed1c0899_03225062($_smarty_tpl) {?>
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


                <li>
                  <?php echo $_smarty_tpl->getSubTemplate ('common/notifications.tpl', $_smarty_tpl->cache_id, $_smarty_tpl->compile_id, 0, null, array(), 0);?>

                </li>

                <li class="active">
                  <a href="../profile/personalPage.php">
                    <div>
                      <span class="float-left glyphicon glyphicon-user"></span>
                      <h6 id="login_status" class="float-right text-white"> </h6>
                    </div>
                  </a>
                </li>

                <li ><a href="../../actions/authentication/action_logout.php"><span class="glyphicon glyphicon-log-out"></span></a></li><!--TODO action logout-->
            </ul>
        </div>
    </div>
</nav>
<?php }} ?>
