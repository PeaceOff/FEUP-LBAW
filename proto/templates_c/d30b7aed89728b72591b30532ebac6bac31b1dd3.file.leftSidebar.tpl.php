<?php /* Smarty version Smarty-3.1.15, created on 2017-04-14 16:46:03
         compiled from "..\..\templates\common\leftSidebar.tpl" */ ?>
<?php /*%%SmartyHeaderCode:1617258f0e0ab469615-27220146%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'd30b7aed89728b72591b30532ebac6bac31b1dd3' => 
    array (
      0 => '..\\..\\templates\\common\\leftSidebar.tpl',
      1 => 1492180960,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '1617258f0e0ab469615-27220146',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'folders' => 0,
    'folder' => 0,
    'project' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.15',
  'unifunc' => 'content_58f0e0ab4d2af0_54726482',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_58f0e0ab4d2af0_54726482')) {function content_58f0e0ab4d2af0_54726482($_smarty_tpl) {?><div id="sidebar-left" class="col-sm-2 padding-0 minimized color-grey">
  <div class="left-sidebar-btn">
    <i class="fa fa-chevron-right hide-actor" target="sidebar-left" style="cursor : pointer"></i>
  </div>
  <ul class="sidebar-nav">
    <?php  $_smarty_tpl->tpl_vars['folder'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['folder']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['folders']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['folder']->key => $_smarty_tpl->tpl_vars['folder']->value) {
$_smarty_tpl->tpl_vars['folder']->_loop = true;
?>
    <li class="open divider">
        <a href="#" data-toggle="collapse" data-target="#<?php echo $_smarty_tpl->tpl_vars['folder']->value['id'];?>
"><?php echo $_smarty_tpl->tpl_vars['folder']->value['name'];?>
<span class="caret"></span></a>
        <ul class="collapse" id="<?php echo $_smarty_tpl->tpl_vars['folder']->value['id'];?>
">
          <?php  $_smarty_tpl->tpl_vars['project'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['project']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['folder']->value['projects']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['project']->key => $_smarty_tpl->tpl_vars['project']->value) {
$_smarty_tpl->tpl_vars['project']->_loop = true;
?>
            <li>
              <a href="<?php echo $_smarty_tpl->tpl_vars['project']->value['page'];?>
"><?php echo $_smarty_tpl->tpl_vars['project']->value['name'];?>
</a>
            </li>
          <?php } ?>
        </ul>
    </li>
    <?php } ?>
  </ul>
</div>


    <!-- Exemplo
      <li class="open divider">
          <a href="#" data-toggle="collapse" data-target="#folder1">Folder 1<span class="caret"></span></a>
          <ul class="collapse" id="folder1">
              <li>
                  <a href="../project/projectPage.php">Project 01</a>
              </li>
              <li>
                  <a href="../project/projectPage.php">Project 02</a>
              </li>
          </ul>
      </li>
    -->
<?php }} ?>
