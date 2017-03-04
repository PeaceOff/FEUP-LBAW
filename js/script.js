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
  console.log("Here");
  $('.toggler').click(function(){
    togglers.each(function(i){
      $(this).parent().removeClass('active');
    });
    $(this).parent().addClass('active');
  });

}

function touch_addListener(){
  var touchPosition = {x:0,y:0};

  document.addEventListener('touchstart',function(e){
    touchPosition.x = e.changedTouches[0].pageX;
    touchPosition.y = e.changedTouches[0].pageY;
  }, false);
  document.addEventListener('touchend',function(e){
    var diffx = e.changedTouches[0].pageX - touchPosition.x;
    var diffy = e.changedTouches[0].pageY - touchPosition.y;

    if(Math.atan2(Math.abs(diffy), Math.abs(diffx)) < Math.PI*20/180 && Math.abs(diffx) > 30){
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

$(document).ready(function(){
  if($(".view").length > 0) $("body").addClass('view');

  setupDatePickers();
  touch_addListener();
  toggler_addListener();

  setTimeout(function(){
    $("body").removeClass("preload");
  },500);
  $('.hide-actor').each(addShow);

});

Dropzone.options.autoProcessQueue = false; // this way files we only be uploaded whrn we call myDropzone.processQueue()
Dropzone.options.addRemoveLinks = true;
