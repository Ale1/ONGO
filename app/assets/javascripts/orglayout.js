

// text resizer:
$(function() {
    var span = $('#my-resizer');
    var fontSize = 50
    console.log("starting resizing")

    do {
      console.log('resized')
        fontSize--;
        span.css('font-size', fontSize.toString() + 'px');
    } while (span.width() >= 265);
});



$(document).ready(function(){
  console.log("is this running?")


// info tabs and buttons:

  $('#org-homepage').show()

  $(".org-header-left").click(function() {
    $('#org-homepage').show()
    $('#org-programs').hide()
    $("#org-financials").hide()
    $("#org-team").hide()
    $("#org-affiliations").hide()
    $('#piechart').hide()
    $('#youtube-panel').show()
    ('#twitter-panel').show()

  });


  $('#org-programs-butt').click(function() {
    $('#org-homepage').hide()
    $("#org-programs").show()
    $("#org-financials").hide()
    $("#org-team").hide()
    $("#org-affiliations").hide()
    $('#piechart').hide()
    $('#youtube-panel').show()
    $('#twitter-panel').show()
  });

  $("#org-financials-butt").click(function() {
    $('#org-homepage').hide()
    $("#org-financials").show()
    $("#org-programs").hide()
    $("#org-team").hide()
    $("#org-affiliations").hide()
    $('#piechart').show()
    $('#youtube-panel').hide()
    $('#twitter-panel').hide()
  });


  $("#org-team-butt").click(function() {
    $('#org-homepage').hide()
    $("#org-financials").hide()
    $("#org-programs").hide()
    $("#org-team").show()
    $("#org-affiliations").hide()
    $('#piechart').hide()
    $('#twitter-panel').show()
  });

  $("#org-affiliations-butt").click(function() {
    $('#org-homepage').hide()
    $("#org-financials").hide()
    $("#org-programs").hide()
    $("#org-team").hide()
    $("#org-affiliations").show()
    $('#piechart').hide()
    $('#youtube-panel').show()
    $('#twitter-panel').show()
  });


});





