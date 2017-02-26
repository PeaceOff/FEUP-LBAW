$(function() {
    $('#signInLink').click(function(e) {
    $("#signIn-form").delay(100).fadeIn(100);
 		$("#signUp-form").fadeOut(100);
		e.preventDefault();
	});

	  $('#signUpLink').click(function(e) {
		$("#signUp-form").delay(100).fadeIn(100);
 		$("#signIn-form").fadeOut(100);
		e.preventDefault();
	});

});
