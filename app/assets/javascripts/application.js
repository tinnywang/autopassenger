// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-timepicker
//= require_tree .

$(document).ready(function() {
  $('.timepicker').timepicker({
    minuteStep: 5,
    showInputs: false,
    disableFocus: true
  });

  $('#email').popover({
    html: true,
    placement: 'right',
    trigger: 'hover',
    title: 'Why should I provide my email?',
    content: "We'll email your boarding pass to you.  We won't use your email for any other purpose.  If you don't receive an email from AutoPassenger shortly after your check in time, you should check in through <a href='http://www.southwest.com/flight/retrieveCheckinDoc.html'>Southwest Airlines</a>."
  });
});


