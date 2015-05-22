function showSignUp(target){
  document.getElementById(target).style.display = 'block';
  document.getElementById("signin").style.display = 'none';
}

function hideSignUp(target){
  document.getElementById(target).style.display = 'none';
  document.getElementById("signin").style.display = 'block';
}

 var backgroundURL = [
    'http://coconutoil.com/wp-content/uploads/sites/6/2013/04/coconuts-1024x682.jpg',
    'http://www.valiant2vape.co.uk/ekmps/shops/b1632a/images/coconut-566-p.jpg',
    'http://sarahhorowitz.com/images/coconutmilk.jpg',
    'http://coconutoilcooking.com/wp-content/uploads/2013/03/Hi-Res-Large-Coconut.jpg'
  ]
  var backStep = 0;

  var backgroundTimer = setInterval(function(){
    backStep++;
    if(backStep == backgroundURL.length) { 
      backStep = 0; 
    };
    var imageUrl = backgroundURL[backStep];
    setTimeout(function(){
      $('.front-page-pic').fadeOut(1000, function(){
        $('.front-page-pic').css('background-image', 'url(' + imageUrl + ')');
        $('.front-page-pic').fadeIn(1000);
      });
    });
  }, 3000);