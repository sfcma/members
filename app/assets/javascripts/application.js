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
//= require_tree .

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
    $('.hideInstruments').show();
    var div = "<div class='field'><input type='text' name='member[member_instruments_attributes][" + instCount + "][instrument]' id='member_member_instruments_attributes_" + instCount + "_instrument'>";
    div += "&emsp;<i><a style='display: none;' href='#' class='removeLink' id='removeMemberInstrument" + instCount + "'>Remove</a><b id='instErr_" + instCount + "' class='instErr'></b></i></div>";

    $('#memberInstrumentsBlock').append(div)
    attachAC('#' + $(div).children().first('input').attr('id'));
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
      if($('#instErr_' + id).html().length == 0) {
        alert("This instrument (" + removableInstrument + ") has been played by this member in a set! Need to change or remove set before removing it here.");
        return false;
      }
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
    var id = $(e.target).attr('id').split('member_member_instruments_attributes_')[1].split('_instrument')[0];
    if (findDuplicateInstruments() == true && returnDuplicateInstruments().indexOf($(e.target).val().toLowerCase()) > -1) {
      if ($('#member_member_instruments_attributes_' + id + '_id').length === 0) {
        $('#instErr_' + id).show().html("&emsp;Duplicate -- please remove");
        e.preventDefault();
      }
    } else {
      $('#instErr_' + id).hide().html("");
      updateInstrumentsInDropdown();
    }
  });


  $('a#addNewMemberSet').on('click', function(e) {
    e.preventDefault();
    setOptions = "";
    for (set in setsForDropdown) {
      setOptions += "<option value='" + setsForDropdown[set][0] + "'>" + setsForDropdown[set][1] + "</option>";
    }
    playStatuses = "";
    for (ps in playStatusesForDropdown) {
      playStatuses += "<option value='" + playStatusesForDropdown[ps].replace("'", "&apos;") + "'>" + playStatusesForDropdown[ps] + "</option>";
    }
    var div = "<div class='field memberInfoBlock'> \
           <select name='member[member_sets_attributes][" + setCount +"][performance_set_id]' id='member_member_sets_attributes_" + setCount +"_performance_set_id'> \
             <option value=''>Please select set name</option>" + setOptions + " \
           </select> \
           &emsp;<i><a style='display: none;' href='#' class='removeLink' id='removeMemberSet" + setCount +"'>Remove Member from Set</a></i><br> \
           <div class='restOfSet' id='restOfSet" + setCount + "'> \
           &emsp;Playing Status: \
            <select name='member[member_sets_attributes][" + setCount +"][set_status]' id='member_member_sets_attributes_" + setCount +"_set_status'> \
            " + playStatuses + "</select> \
            <span class='setStatusModalOpener button'>What Does This Mean?</span><br> \
            &emsp;Rotating this set? \
            <input name='member[member_sets_attributes][" + setCount +"][rotating]' value='0' type='hidden'> \
            <input value='1' name='member[member_sets_attributes][" + setCount +"][rotating]' id='member_member_sets_attributes_" + setCount +"_rotating' type='checkbox'> \
            <br> \
            &emsp;Instruments played this set: \
            <select name='member[member_sets_attributes][" + setCount +"][set_member_instruments_attributes][0][member_instrument_id]'  \
                    id='member_member_sets_attributes_" + setCount +"_set_member_instruments_attribfalseutes_0_member_instrument_id'> \
            </select> \
          </div></div>";

    $('#setMaster').append(div);
    updateInstrumentsInDropdown();
    setCount++;
    return false;
  });

  $(document).on('click', 'a[id^=removeMemberSet]', function(ev) {
    ev.preventDefault();
    var obj = ev.target;
    var id = $(obj).attr('id').split('removeMemberSet')[1];
    $('#member_member_sets_attributes_' + id + '_performance_set_id').attr('id', 'member_member_sets_attributes_' + id + '__destroy');
    $('#member_member_sets_attributes_' + id + '__destroy').replaceWith('<input type="hidden" value="1" name="member[member_sets_attributes][' + id + '][_destroy]" id="member_member_sets_attributes_' + id + '__destroy">');
    $(obj).parent().html('Removed');
    $('#restOfSet' + id).detach();
    return false;
  });

  $('.closeHelp').on('click', function(e) {
    $('#playerStatusModal').hide();
  });

  $('#playerStatusModalOpener').on('click', function(e) {
    $('#playerStatusModal').show();
  });

  $('.closeHelp').on('click', function(e) {
    $('#setStatusModal').hide();
  });

  $(document).on('click', '.setStatusModalOpener', function(e) {
    $('#setStatusModal').show();
  });

  function findIfDuplicates(arr) {
    var result = [];
    var dupFound = false;
    arr.forEach(function(item) {
       if(result.indexOf(item) >= 0) {
         if(item != 0) {
           dupFound = true;
           return;
         }
       } else {
         result.push(item);
       }
    });
    return dupFound;
  }

  function findDuplicates(arr) {
    var result = [];
    var dupFound = [];
    arr.forEach(function(item) {
       if(result.indexOf(item) >= 0) {
         if(item != 0) {
           dupFound.push(item);
         }
       } else {
         result.push(item);
       }
    });
    return dupFound;
  }

  $('div.actions').on('click', '#memberSubmissionForm', function(ev) {
    $('.errZone').html("");

    // Check duplicate sets
    var setNames = [];
    $('select[id^=member_member_sets_attributes_][id$=performance_set_id]').each(function() {
      setNames.push($(this).val());
    });
    if(findIfDuplicates(setNames) == true) {
      $('.errZone').show().html($('.errZone').html() + 'This member is signed up more than once for the same set, which is not permitted. Please correct the sets above.');
      ev.preventDefault();
      return false;
    }

    // Check missing instruments
    $('select[id^=member_member_sets_attributes_]:visible').each(function() {
      if ($(this).val() == "" || $(this).val() == null) {
        $('.errZone').show().html($('.errZone').html() + 'Not all sets have instruments specified. Please specify instrument played in each set and try again.');
        ev.preventDefault();
        return false;
      }
    });

    // Check duplicate instruments
    if (findDuplicateInstruments() == true) {
      $('.errZone').show().html($('.errZone').html() + 'This member is listed under the same instrument twice. Please remove one of them.');
      ev.preventDefault();
      return false;
    }
  });

  function findDuplicateInstruments() {
    var instNames = [];
    $('input[id^=member_member_instruments_attributes][id$=_instrument]:visible').each(function() {
      instNames.push($(this).val().toLowerCase());
    });
    return findIfDuplicates(instNames);
  }

  function returnDuplicateInstruments() {
    var instNames = [];
    $('input[id^=member_member_instruments_attributes][id$=_instrument]:visible').each(function() {
      instNames.push($(this).val().toLowerCase());
    });
    return findDuplicates(instNames);
  }

  $('div').on('change', 'select[id^=member_member_sets_attributes]', function(e) {
    e.preventDefault();
    var id = e.target.id.split('member_member_sets_attributes_')[1].split('_')[0];
    if ($(e.target).val() == "") {
      $(e.target).parents('.memberInfoBlock').find('a[id^=removeMemberSet]').hide();
      $('#restOfSet' + id).hide();
    } else {
      $(e.target).parents('.memberInfoBlock').find('a[id^=removeMemberSet]').show();
      $('#restOfSet' + id).show();
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

  // Member#index
  $('#setSelector').on('change', function(e) {
    window.location.href = location.protocol + '//' + window.location.hostname + (location.port ? ':'+location.port: '') + '/members?set=' + e.target.value;
  });

  $('#instrumentSelector').on('change', function(e) {
    window.location.href = location.protocol + '//' + window.location.hostname + (location.port ? ':'+location.port: '') + '/members?instrument=' + e.target.value;
  });

  // Absence#index
  $('#setSelectorAbsence').on('change', function(e) {
    window.location.href = location.protocol + '//' + window.location.hostname + (location.port ? ':'+location.port: '') + '/absences?set=' + e.target.value;
  });

  // Absence#show
  $('#open_absence_sub_box').on('click', function(e) {
    $('.edit_absence').toggle();
  });

  // For Absence#new page
  $('#absence_performance_set_dates_performance_set_id').on('change', function() {
    var rehearsalSel = $('#absenceRehearsalDateSelector');
    var newOptions = "";
    var performanceSetId = $('#absence_performance_set_dates_performance_set_id').val();
    $.get('../../performance_sets/' + performanceSetId + '/rehearsal_dates').then(function(response) {
      $.each(response, function(rehearsal) {
        var dt = moment(response[rehearsal].date).format('dddd, MMMM Do YYYY');
        newOptions += '<option value=' + response[rehearsal].id + '>' + dt + '</option>';
      });
      rehearsalSel.prop('disabled', false);
      rehearsalSel.empty().append($(newOptions));
    });
  });

  // For MemberSet#new page
  $('#member_set_performance_set_id').on('change', function() {
    var rehearsalSel = $('#member_set\\[new_performance_set_instrument_id\\]');
    var newOptions = "";
    var performanceSetId = $('#member_set_performance_set_id').val();
    $.get('../../performance_set_instruments/?performance_set_id=' + performanceSetId).then(function(response) {
      $.each(response, function(instrument) {
        var inst = response[instrument].instrument;
        newOptions += '<option value=' + response[instrument].instrument + '>' + inst + '</option>';
      });
      rehearsalSel.prop('disabled', false);
      rehearsalSel.empty().append($(newOptions));
    });
  });

  if (isNew) {
    $('a[id^=removeMemberSet]').hide();
    $('a[id^=removeMemberInstrument]').hide();
  }


};

var instruments =
  [ "Piccolo",
    "Flute",
    "Oboe",
    "B Flat Clarinet",
    "E Flat Clarinet",
    "Bass Clarinet",
    "English Horn",
    "Bassoon",
    "Contrabassoon",
    "Alto Saxophone",
    "Tenor Saxophone",
    "Trumpet",
    "French Horn",
    "Trombone",
    "Bass Trombone",
    "Tuba",
    "Timpani",
    "Percussion",
    "Piano",
    "Violin",
    "Viola",
    "Cello",
    "String Bass"
  ]

function attachAC(id) {
  $(id).autoComplete({
    minChars: 1,
    source: function(term, suggest) {
      term = term.toLowerCase();
      var choices = instruments;
      var matches = [];
      for (i=0; i<choices.length; i++) {
        if (~choices[i].toLowerCase().indexOf(term)) {
          matches.push(choices[i]);
        }
      }
      suggest(matches);
    }
  });
}


$(document).ready(loadStuff);
