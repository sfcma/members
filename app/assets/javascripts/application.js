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
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

Turbolinks.start()


var loadStuff = function() {
  $('a#addNewMemberInstrument').on('click', function(e) {
    e.preventDefault();
    var topId = instCount - 1;

    topId = 'member_member_instruments_attributes_' + topId + '_instrument';
    var div = "<div class='field'><input type='text' name='member[member_instruments_attributes][" + instCount + "][instrument]' id='member_member_instruments_attributes_" + instCount + "_instrument'></div>";
    console.log($('#' + topId), $('#' + topId).parent());
    console.log($(div));
    $(div).insertAfter($('#' + topId).parent());
    instCount++;
    return false;
  });

  $('a[id^=removeMemberInstrument]').on('click', function(e) {
    e.preventDefault();
    var obj = e.target;
    var id = $(obj).attr('id').split('removeMemberInstrument')[1];
    $('#member_member_instruments_attributes_' + id + '_instrument').attr('id', 'member_member_instruments_attributes_' + id + '__destroy');
    $('#member_member_instruments_attributes_' + id + '__destroy').attr('name', 'member[member_instruments_attributes][' + id + '][_destroy]');
    $('#member_member_instruments_attributes_' + id + '__destroy').attr('value', '1');
    $('#member_member_instruments_attributes_' + id + '__destroy').attr('type', 'hidden');
    $(obj).parent().html('Removed');
    return false;
  });
};

document.addEventListener('turbolinks:load', loadStuff);
