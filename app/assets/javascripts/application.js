// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require jquery.min.js
//= require jquery_ujs
//= require modernizr-2.6.2.min.js
//= require jquery.easing.1.3.js
//= require bootstrap.min.js
//= require owl.carousel.min.js
//= require jquery.stellar.min.js
//= require jquery.waypoints.min.js
//= require jquery.countTo.js
//= require main.js
//= require marquee.js
//= require respond.min-.js
//= require_tree .

function myFunction() {
  var x = document.getElementById('myDIV');
  if (x.style.display === 'none') {
    x.style.display = 'block';
  } else {
    x.style.display = 'none';
  }
}

$(document).ready(function() {
  var maxLength = 150;
  $(".show-read-more").each(function () {
    var myStr = $(this).text();
    if ($.trim(myStr).length > maxLength) {
      var newStr = myStr.substring(0, maxLength);
      var removedStr = myStr.substring(maxLength, $.trim(myStr).length);
      $(this).empty().html(newStr);
      $(this).append(' <a href="javascript:void(0);" class="read-more">read more...</a>');
      $(this).append('<span class="more-text">' + removedStr + '</span>');
    }
  });
  $(".read-more").click(function () {
    $(this).siblings(".more-text").contents().unwrap();
    $(this).remove();
  });
});
