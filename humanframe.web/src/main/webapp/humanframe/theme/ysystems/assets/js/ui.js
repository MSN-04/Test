var sh,sc
$(document).ready(function() {
      sh = window.innerHeight
      ww = window.innerWidth
      $('section.cover').height(sh);
      if(ww < 500){
        $('#home').height(sh+300)
      }
      

  $('.closebtn').on('mouseover', function() {
      $(this).children().addClass('open');
  });
  $('.closebtn').on('mouseout', function() {
      $(this).children().removeClass('open');
  });

  $('nav a.project-question').click(function(){
    $('body').addClass('p');
    return false;
  })
  $('.closebtn').click(function(){
    $('body').removeClass('p');
    return false;
  })

});
$(window).load(function(){
      $('#menu-home').click(function(){
         $(window).scrollTo(0,500);
         return false;
      })
      $('#menu-services').click(function(){
         $(window).scrollTo($('section.services'),500);
         return false;
      })
      $('#menu-overview').click(function(){
          $(window).scrollTo($('section.overview'),500);
         return false;
      })
      $('#menu-recruit').click(function(){
          $(window).scrollTo($('section.recruit'),500);
         return false;
      })
      $('#menu-contact').click(function(){
          $(window).scrollTo($('section.contact'),500);
         return false;
      })
})
$(window).bind('scroll',function(){
    sc = $(window).scrollTop();
    if (sc > 400) {
      $('header').addClass('w');
      $('.mousescroll-notice').hide();
    } else {
      $('header').removeClass('w')
      $('.mousescroll-notice').show();
    }
     if (sc > 400 && sc < 1500) {
      $('#rotate').addClass('r')
     }  else {
      $('#rotate').removeClass('r')
     }
})

