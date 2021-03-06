function setupTodoListeners() {

    $('#To-Do_button').click(function() {
        
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

        }).fail(function() {
            // TODO handle failure
        });

    });

    $('#Doing_button').click(function() {
        
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

        }).fail(function() {
            // TODO handle failure
        });
    });

    $('#Done_button').click(function() {
        
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

            var template = $.templates("#api_tmpl");
            var htmlOutput = template.render(data);
	    elem.html(htmlOutput);

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
			alert($_GET('project_id'));
			$.ajax({
				type: "POST",
				url: "../../actions/project/action_remove_user.php",
				data: { username: username, project_id: $_GET('project_id')}
			}).done(function(arg){console.log(arg)});
		$(this).parent().parent().remove();
	});
}

function add_user(){
	$('#form-addUser').keypress(function(e) {
		if( e.charCode == 13){
			var username = $(this).val();
			$.ajax({
				type: "POST",
				url: "../../actions/project/action_add_user.php",
				data: { username: username, project_id: $_GET('project_id')}
			}).done(function(arg){console.log(arg)});
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
  $('#datetimepicker').attr('type', 'text');
  $("#datetimepicker").datetimepicker({
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
  setupDatePickers();
  touch_addListener();
  toggler_addListener();
  openModals();
  add_user();
  remove_user();
  remove_project();
  remove_document();
  setTimeout(function(){
    $("body").removeClass("preload");
  },500);
  $('.hide-actor').each(addShow);

});
Dropzone.options.autoProcessQueue = false; // this way files we only be uploaded whrn we call myDropzone.processQueue()
Dropzone.options.addRemoveLinks = true;
