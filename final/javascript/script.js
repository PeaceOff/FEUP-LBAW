
function createWarningBox(){
	
	var e = $(document.createElement('div'));
	e.addClass('box-alerts');
	$('body').append(e);

}

function addWarning(type, msg){
	
	var e = $(document.createElement('div'));
  var alertType = 'alert alert-';
	alertType += type;	
	e.addClass(alertType);
	type = type.charAt(0).toUpperCase() + type.slice(1);
	var message = '<strong>'+ type  +'</strong>'+ msg;
	e.append(message);
	$('.box-alerts').append(e); 
	setTimeout(function() {
		e.remove();
	}, 2000);
}
function addUser(username){
	var element = $('.template tr').clone(true);
	console.log(element.html());
	console.log($('.template tr').html());
	element.find('.template_name').html(username);
	element.find('.link_removeUser').attr('username',username);
	$('#project-users tbody').append(element);

}
function setupForumListeners() {

    $('.forum_button').click(function() {
        console.log("Forum Clicked");
    });
}

function clearAll(){
	$('#To-Do').empty();
	$('#Doing').empty();
	$('#Done').empty();
}

function setupTodoListeners() {

    $('#To-Do_button').click(function() {
       clearAll(); 
	var elem = $('#To-Do');
        
        if(elem.children().length > 0)
            return;
        
        var proj_id = location.search.replace('?', '').split('=')[1];

        $.ajax({
            type: "post",
            dataType: "json",
            url: '../../api/get_task_by_category.php',
            data: {'category' : "To-Do", 'project_id' : proj_id}
        }).done(function(data) {

            var template = $.templates("#api_tmpl");
	    var htmlOutput = template.render(data);
	    elem.html(htmlOutput);
		setup_information();
        }).fail(function() {
            // TODO handle failure
        });

    });

    $('#Doing_button').click(function() {
        
       clearAll(); 
	var elem = $('#Doing');
        
        if(elem.children().length > 0)
            return;
        
        var proj_id = location.search.replace('?', '').split('=')[1];

        $.ajax({
            type: "post",
            dataType: "json",
            url: '../../api/get_task_by_category.php',
            data: {'category' : "Doing", 'project_id' : proj_id}
        }).done(function(data) {

            var template = $.templates("#api_tmpl");
	    var htmlOutput = template.render(data);
	    elem.html(htmlOutput);
		setup_information();
        }).fail(function() {
            // TODO handle failure
        });
    });

    $('#Done_button').click(function() {
        
       clearAll(); 
	var elem = $('#Done');

        if(elem.children().length > 0)
            return;
        
        var proj_id = location.search.replace('?', '').split('=')[1];

        $.ajax({
            type: "post",
            dataType: "json",
            url: '../../api/get_task_by_category.php',
            data: {'category' : "Done", 'project_id' : proj_id}
        }).done(function(data) {
			console.log(data);
            var template = $.templates("#api_tmpl");
            var htmlOutput = template.render(data);
	    elem.html(htmlOutput);
		setup_information();
        }).fail(function() {
            // TODO handle failure
        });
    });
}

function addShow(index){
  var target = $(this).attr("target");

  $(this).click(function(){
    toggleSideBar(target);
  });
}

function toggleSideBar(target){
  if($(window).width()  < 768)
    $('.show').each(function(index){
      if($(this)[0].id != target)
        $(this).removeClass('show');
    });
  $("#"+target).toggleClass("show");
}

function toggler_addListener(){
  var togglers = $('.toggler');
  $('.toggler').click(function(){
    togglers.each(function(i){
      $(this).parent().removeClass('active');
    });
    $(this).parent().addClass('active');
  });

}

function $_GET(param) {
	var vars = {};
	window.location.href.replace( location.hash, '' ).replace(
		/[?&]+([^=&]+)=?([^&]*)?/gi, // regexp
		function( m, key, value ) { // callback
			vars[key] = value !== undefined ? value : '';
		}
	);

	if ( param ) {
		return vars[param] ? vars[param].replace("#","") : null;
	}
	return vars.replace("#","");
}

function remove_document(){

	$('.link_deleteDocument').click(function() {

			var documentId= $(this).attr('id');

			var success;
			$.ajax({
				type: "POST",
				url: "../../actions/project/action_delete_document.php",
				data: {project_id: $_GET('project_id'), document_id: documentId}
			}).done(function(arg){
				console.log(arg);
			});

			$(this).parent().remove();

	});
}

function remove_project(){

	$('.link_deleteProject').click(function() {
			var projectId= $(this).parent().find('.project_id').val();

			$.ajax({
				type: "POST",
				url: "../../actions/profile/action_delete_project.php",
				data: {project_id: projectId}
			});

			$(this).parent().parent().remove();

	});
}



function remove_user(){
	$('.link_removeUser').click(function() {
			var username = $(this).attr('username');
			$.ajax({
				type: "POST",
				url: "../../actions/project/action_remove_user.php",
				data: { username: username, project_id: $_GET('project_id')}
			}).done(function(arg){	
				addWarning('success','User Deleted!');
			}).fail(function(){
				addWarning('warning','User NOT Found!');
			});

			$(this).parent().parent().remove();
	});
}

function get_task_information(){

	$('.btn_edit_task').click(function() {
		var task_id = $(this).attr('task_id');		
		$.ajax({
            		type: "post",
            		dataType: "json",
            		url: '../../api/get_task_info.php',
            		data: {'task_id' : task_id}
		}).done(function(arg){
			console.log(arg);
			$('.task_description').html(arg['description']);
			$('.task_deadline').attr('value', arg['deadline']);
			$('.task_category').attr('value', arg['category']);
		}).fail(function(arg){
			console.log("Error = " + arg);
		});		
	
	});
}


function get_project_information(){

	$('.btn_project_edit').click(function() {
		var id = $(this).attr('project_id');
		$('.hidden_projectId').attr('value',id);
		
		$.ajax({
            		type: "post",
            		dataType: "json",
            		url: '../../api/get_project_info.php',
            		data: {'project_id' : id}
		}).done(function(arg){
			$('.project_folder').attr('value', arg['folder']['name']);
			$('.project_description').html(arg['description']);
			$('.project_deadline').attr('value', arg['deadline']);
		}).fail(function(arg){
			
		});		
	
	});
}


function update_project(){
	$('.link_update_project').click(function() {
		
			$.ajax({
				type: "POST",
				url: "../../actions/profile/action_edit_project.php",
				data: {project_id: projectId}
			}).done(function(arg){	
				addWarning('success','Project updated!');
			}).fail(function(){
				addWarning('warning','Updated failed');
			});

		});
}


function add_user(){
	$('#form-addUser').keypress(function(e) {
		key = (e.keyCode)? e.keyCode : e.charCode;
		if( key == 13){
			console.log("HERE");
			var username = $(this).val();
			$.ajax({
				type: "POST",
				url: "../../actions/project/action_add_user.php",
				data: { username: username, project_id: $_GET('project_id')}
			}).done(function(arg){
				addWarning('success','User successfully added!');
				addUser(username);
			}).fail(function(){
				addWarning('warning','User NOT Found!');
			});
		}
	});
}


function touch_addListener(){
  var touchPosition = {x:0,y:0};
  var calculate = false;
  var size = 20;
  document.addEventListener('touchstart',function(e){

    touchPosition.x = e.changedTouches[0].pageX;
    touchPosition.y = e.changedTouches[0].pageY;
    calculate = touchPosition.x < size || touchPosition.x > $(window).width() - size;
  }, false);
  document.addEventListener('touchend',function(e){
    if(!calculate)
      return;
    var diffx = e.changedTouches[0].pageX - touchPosition.x;
    var diffy = e.changedTouches[0].pageY - touchPosition.y;

    if(Math.atan2(Math.abs(diffy), Math.abs(diffx)) < Math.PI*15/180 && Math.abs(diffx) > 30){
      if(diffx < 0){
        toggleSideBar("sidebar-right");
      }else{
        toggleSideBar("sidebar-left");
      }
    }

  }, false);
}

function setupDatePickers(){
  $('.datetimepicker').attr('type', 'text');
  $(".datetimepicker").datetimepicker({
    format: 'DD/MM/YYYY'
  });
}

function openModals(){
  var get_vars = window.location.search.substring(1);
  var single_vars = get_vars.split('&');
  for (var i = 0; i < single_vars.length; i++)
  {
      var param_name = single_vars[i].split('=');
      if (param_name[0] == "action")
          $("#"+param_name[1]).modal('show');
  }
}

$(document).ready(function(){
  if($(".view").length > 0) $("body").addClass('view');

  setupTodoListeners();
  setupForumListeners();
  setupDatePickers();
  touch_addListener();
  toggler_addListener();
  openModals();
  add_user();
  remove_user();
  remove_project();
  remove_document();
  get_project_information();
  get_task_information();
  update_project();
  setTimeout(function(){
    $("body").removeClass("preload");
  },500);
	createWarningBox();
  $('.hide-actor').each(addShow);

});
Dropzone.options.autoProcessQueue = false; // this way files we only be uploaded whrn we call myDropzone.processQueue()
Dropzone.options.addRemoveLinks = true;
