<?php /* Smarty version Smarty-3.1.15, created on 2017-04-14 19:49:04
         compiled from "..\..\templates\common\notifications.tpl" */ ?>
<?php /*%%SmartyHeaderCode:2685358f0e7b4951652-19352282%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '939ca7864566cc9177ded4361c521e5da659fda3' => 
    array (
      0 => '..\\..\\templates\\common\\notifications.tpl',
      1 => 1492190758,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '2685358f0e7b4951652-19352282',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.15',
  'unifunc' => 'content_58f0e7b4975504_07356714',
  'variables' => 
  array (
    'notification_number' => 0,
    'notifications' => 0,
    'notification' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_58f0e7b4975504_07356714')) {function content_58f0e7b4975504_07356714($_smarty_tpl) {?><a class="btn dropdown-toggle"  id="dLabel" role="button" data-toggle="dropdown" >
  <i class="fa fa-bell" aria-hidden="true" style="font-size : 1.25em"></i>
  <span class="badge badge-notify"><?php echo $_smarty_tpl->tpl_vars['notification_number']->value;?>
</span>
</a>
<div class="dropdown-menu" role="menu" >
  <ul class="notifications padding-left-0" aria-labelledby="dLabel">
    <li>
      <div class="notification-heading">
        <h4 class="notifications-title">Notifications</h4>
        <?php if ($_smarty_tpl->tpl_vars['notification_number']->value!=0) {?>
        <a href="#"> <h4 class="notifications-title pull-right">Dismmiss all    <i class="fa fa-arrow-right" aria-hidden="true"></i></h4> </a><!--TODO delete das notificacoes-->
        <?php }?>
      </div>
    </li>
    <li class="divider"></li>
    <li>
    <div class="notifications-wrapper" style="overflow-y:scroll;">
      <?php  $_smarty_tpl->tpl_vars['notification'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['notification']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['notifications']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['notification']->key => $_smarty_tpl->tpl_vars['notification']->value) {
$_smarty_tpl->tpl_vars['notification']->_loop = true;
?>
        <div class="notification-item">
          <h4 class="item-title"><?php echo $_smarty_tpl->tpl_vars['notification']->value['description'];?>
</h4>
          <p class="item-info"><?php echo $_smarty_tpl->tpl_vars['notification']->value['time'];?>
</p>
          <div class="notification-links pull-right">
            <?php if ($_smarty_tpl->tpl_vars['notification']->value['invite']) {?>
            <a><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></a><!--TODO accept invite-->
            <a><i class="fa fa-times-circle fa-2x" aria-hidden="true"></i></a><!--TODO decline invite-->
            <?php } else { ?>
            <a><i class="fa fa-check fa-2x" aria-hidden="true"></i>  </a> <!--Delete notification-->
            <?php }?>
          </div>
        </div>
      <?php } ?>
    </li>
    <li class="divider"></li>
  </ul>
</div>
      <!--Exemplos
        <div class="notification-item">
          <h4 class="item-title">David Azevedo Invited you to join LBAW-A3</h4>
          <p class="item-info">27-02-2017, one day ago</p>
          <div class="notification-links pull-right">
            <a><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></a>
            <a><i class="fa fa-times-circle fa-2x" aria-hidden="true"></i></a>
          </div>
        </div>


        <div class="notification-item">
          <h4 class="item-title">Marcelo Ferreira assigned you to a task on LBAW-A2</h4>
          <p class="item-info">27-02-2017, one day ago</p>
          <div class="notification-links pull-right">
            <a><i class="fa fa-check fa-2x" aria-hidden="true"></i>  </a>
          </div>
        </div>
-->
<?php }} ?>
