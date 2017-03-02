function addShow(index){
  var target = $(this).attr("target");

  $(this).click(function(){
    if($(window).width()  < 768)
      $('.show').each(function(index){
        if($(this)[0].id != target)
          $(this).removeClass('show');
      });
    $("#"+target).toggleClass("show");
  });
}

function toggler_addListener(){
  var togglers = $('.toggler');
  console.log("Here");
  $('.toggler').click(function(){
    togglers.each(function(i){
      $(this).parent().removeClass('active');
    });
    $(this).parent().addClass('active');
  });
}

$(document).ready(function(){
  if($(".view").length > 0) $("body").addClass('view');

  toggler_addListener();
  setTimeout(function(){
    $("body").removeClass("preload");
  },500);
  $('.hide-actor').each(addShow);
});
