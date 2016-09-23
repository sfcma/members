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
  var updateInstrumentsInDropdown = function() {
    var selectedInstruments = {};
    $('select[id^=member_member_sets_attributes_][id$=instrument_id]').each(function(j, i) {
      selectedInstruments[i.id] = $(i).val();
    });
    member_set_instrument_dropdowns = $('select[id^=member_member_sets_attributes][id$=instrument_id]');
    member_set_instrument_dropdowns.empty();
    $('input[id^=member_member_instruments_attributes][type=text]').each(function(j, i) {
      member_set_instrument_dropdowns.append( $("<option>")
                                     .val($(i).val())
                                     .html($(i).val()));
    });
    $('select[id^=member_member_sets_attributes_][id$=instrument_id]').each(function(j, i) {
      $(i).val(selectedInstruments[i.id]);
    });
  };

  $('a#addNewMemberInstrument').on('click', function(e) {
    e.preventDefault();
    var div = "<div class='field'><input type='text' name='member[member_instruments_attributes][" + instCount + "][instrument]' id='member_member_instruments_attributes_" + instCount + "_instrument'>";
    div += "&emsp;<i><a style='display: none;' href='#' class='removeLink' id='removeMemberInstrument" + instCount + "'>Remove</a></i></div>";

    $(div).insertAfter($('#memberInstrumentsBlock div:last-of-type'));
    instCount++;
    return false;
  });

  $('.memberInfoBlock').on('click', 'a[id^=removeMemberInstrument]', function(e) {
    e.preventDefault();
    var obj = e.target;
    var id = $(obj).attr('id').split('removeMemberInstrument')[1];
    var removableInstrument = $('#member_member_instruments_attributes_' + id + '_instrument').val();
    var selectedInstrumentsInSets = $('select[id^=member_member_sets_attributes_][id$=instrument_id]').map(function () { return $(this).val(); }).get();

    if (selectedInstrumentsInSets.indexOf(removableInstrument) > -1) {
      alert("This instrument (" + removableInstrument + ") has been played by this member in a set! Need to change or remove set before removing it here.");
      return false;
    }

    $('#member_member_instruments_attributes_' + id + '_instrument').attr('id', 'member_member_instruments_attributes_' + id + '__destroy');
    $('#member_member_instruments_attributes_' + id + '__destroy').attr('name', 'member[member_instruments_attributes][' + id + '][_destroy]');
    $('#member_member_instruments_attributes_' + id + '__destroy').attr('value', '1');
    $('#member_member_instruments_attributes_' + id + '__destroy').attr('type', 'hidden');
    $(obj).parent().html('Removed');
    updateInstrumentsInDropdown();
    return false;
  });

  $('.new_member, .edit_member').on('blur', 'input[id^=member_member_instruments]', function(e) {
    updateInstrumentsInDropdown();
  });


  $('a#addNewMemberSet').on('click', function(e) {
    e.preventDefault();
    var setTopId = setCount - 1;

    setTopId = 'member_member_sets_attributes_' + setTopId + '_set_id';
    setOptions = "";
    for (set in setsForDropdown) {
      setOptions += "<option value='" + setsForDropdown[set][0] + "'>" + setsForDropdown[set][1] + "</option>";
    }

    playStatuses = "";
    for (ps in playStatusesForDropdown) {
      playStatuses += "<option value='" + playStatusesForDropdown[ps] + "'>" + playStatusesForDropdown[ps] + "</option>";
    }
    var div = "<div class='field memberInfoBlock'> \
           <select name='member[member_sets_attributes][" + setCount +"][set_id]' id='member_member_sets_attributes_" + setCount +"_set_id'> \
             <option value=''>Please select</option>" + setOptions + " \
           </select> \
           &emsp;<i><a style='display: none;' href='#' class='removeLink' id='removeMemberSet" + setCount +"'>Remove Member from Set</a></i><br> \
           Playing Status: \
            <select name='member[member_sets_attributes][" + setCount +"][set_status]' id='member_member_sets_attributes_" + setCount +"_set_status'> \
            " + playStatuses + "</select> \
            <span id='setStatusModalOpener'>?</span> \
            Rotating this set? \
            <input name='member[member_sets_attributes][" + setCount +"][rotating]' value='0' type='hidden'> \
            <input value='1' name='member[member_sets_attributes][" + setCount +"][rotating]' id='member_member_sets_attributes_" + setCount +"_rotating' type='checkbox'> \
            <br> \
            Instruments played this set: \
            <select name='member[member_sets_attributes][" + setCount +"][set_member_instruments_attributes][0][member_instrument_id]'  \
                    id='member_member_sets_attributes_" + setCount +"_set_member_instruments_attributes_0_member_instrument_id'> \
            </select> \
          </div>";

    $(div).insertAfter($('#setMaster div:last-of-type'));
    updateInstrumentsInDropdown();
    setCount++;
    return false;
  });

  $('.memberInfoBlock').on('click', 'a[id^=removeMemberSet]', function(e) {
    e.preventDefault();
    var obj = e.target;
    var id = $(obj).attr('id').split('removeMemberSet')[1];
    $('#member_member_sets_attributes_' + id + '_set_id').attr('id', 'member_member_sets_attributes_' + id + '__destroy');
    $('#member_member_sets_attributes_' + id + '__destroy').replaceWith('<input type="hidden" value="1" name="member[member_sets_attributes][' + id + '][_destroy]" id="member_member_sets_attributes_' + id + '__destroy">');
    $(obj).parent().html('Removed');
    return false;
  });

  $('#playerStatusModal').on('click', function(e) {
    $('#playerStatusModal').hide();
  });

  $('#playerStatusModalOpener').on('click', function(e) {
    $('#playerStatusModal').show();
  });

  $('#setStatusModal').on('click', function(e) {
    $('#setStatusModal').hide();
  });

  $('#setStatusModalOpener').on('click', function(e) {
    $('#setStatusModal').show();
  });

  $('tr').on('change', 'select[id^=member_member_sets_attributes]', function(e) {
    e.preventDefault();
    console.log("CHAN")
    if ($(e.target).val() == "") {
      $(e.target).parents('.memberInfoBlock').find('a[id^=removeMemberSet]').hide();
    } else {
      $(e.target).parents('.memberInfoBlock').find('a[id^=removeMemberSet]').show();
    }
  });

  $('.memberInfoBlock').on('change', 'input[id^=member_member_instruments_attributes]', function(e) {
    e.preventDefault();
    if ($(e.target).val() == "") {
      $(e.target).next('i').find('a[id^=removeMemberInstrument]').hide();
    } else {
      $(e.target).next('i').find('a[id^=removeMemberInstrument]').show();
    }
  });

  if (isNew) {
    $('a[id^=removeMemberSet]').hide();
    $('a[id^=removeMemberInstrument]').hide();
  }
};

document.addEventListener('turbolinks:load', loadStuff);
