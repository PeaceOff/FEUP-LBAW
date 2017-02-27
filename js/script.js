$(function() {
    $('#signInLink').click(function(e) {
    $("#signIn-form").delay(100).fadeIn(100);
 		$("#signUp-form").fadeOut(100);
    $("#signUpLink").removeClass('selected');
    $(this).addClass('selected');
  	e.preventDefault();
	});

	  $('#signUpLink').click(function(e) {
		$("#signUp-form").delay(100).fadeIn(100);
 		$("#signIn-form").fadeOut(100);
    $("#signInLink").removeClass('selected');
    $(this).addClass('selected');
  	e.preventDefault();
	});

});

function checkWidth(){
  if($(window).width() < 768)
    $('.dockable').addClass("minimized");
  else
    $('.dockable').removeClass("minimized");
}

function addShow(index){
  var target = $(this).attr("target");

  $(this).click(function(){
    $('.show').each(function(index){
      if($(this)[0].id != target)
        $(this).removeClass('show');
    });
    $("#"+target).toggleClass("show");
  });
}

$(document).ready(function(){
  checkWidth();

  $('.hide-actor').each(addShow);

  $(window).on('resize', function(){
    checkWidth();
  });

});
