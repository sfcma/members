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
      if ($(i).val().toLowerCase() == 'violin') {
        member_set_instrument_dropdowns.append( $("<option>")
                                      .val('violin 1')
                                      .html('violin 1'));
        member_set_instrument_dropdowns.append( $("<option>")
                                      .val('violin 2')
                                      .html('violin 2'));
      }
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
    attachAC('#' + $(div).children().first('input').attr('id'), false);
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

  $('#member_custom_source_button').on('click', function(e) {
    $('.member_custom_source_box').show();
  });

  $('#member_website_source_button').on('click', function(e) {
    $('.member_custom_source_box').hide();
  });

  $('a#addNewMemberNote').on('click', function(e) {
    e.preventDefault();
    $('.hideNotes').show();
    var div = "<div class='field'><input type='text' name='member[member_notes_attributes][" + notesCount + "][note]' size=50 id='member_member_notes_attributes_" + notesCount + "_note'>";
    div += "<label for='member_member_notes_attributes_" + notesCount + "_private_note'><input name='member[member_notes_attributes][" + notesCount + "][private_note]' id='member_member_notes_attributes_" + notesCount + "_private_note' value='0' type='checkbox'>";
    div += "Restricted Note</label></div>";

    $('#memberNotesBlock').append(div)
    notesCount++;
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
      playStatuses += "<option value='" + playStatusesForDropdown[ps] + "'>" + playStatusTextForDropdown[ps] + "</option>";
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
            &emsp;Standby Player this set? \
            <input name='member[member_sets_attributes][" + setCount +"][standby_player]' value='0' type='hidden'> \
            <input value='1' name='member[member_sets_attributes][" + setCount +"][standby_player]' id='member_member_sets_attributes_" + setCount +"_standby_player' type='checkbox'> \
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

  $('#memberEmailStatusesAbsenceSelector').on('change', function(e) {
    var perfSetId = location.href.split('set=')[1].split('&')[0];
    if (perfSetId) {
      window.location.href = location.protocol + '//' + window.location.hostname + (location.port ? ':'+location.port: '') + '/absences?set=' + perfSetId + '&e_status=' + e.target.value;
    }
  });

  // PerformanceSetDates#index
  $('#setSelectorPerfSetDates').on('change', function(e) {
    window.location.href = location.protocol + '//' + window.location.hostname + (location.port ? ':'+location.port: '') + '/performance_set_dates?set=' + e.target.value;
  });

  // PerformanceSet#Roster
  $('#memberEmailStatusesRosterSelector').on('change', function(e) {
    var perfSetId = location.href.split('sets/')[1].split('/')[0];
    if (perfSetId) {
      window.location.href = location.protocol + '//' + window.location.hostname + (location.port ? ':'+location.port: '') + '/performance_sets/' + Number(perfSetId) + '/roster?e_status=' + e.target.value;
    }
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

    var member_email_address = $('#absence_members_email_1').val();
    $.get('../../members/requires_sub_name?member_email=' + member_email_address + '&performance_set_id=' + performanceSetId).then(function(response) {
      if (response === true) {
        $('#sub_found_container').show();
      } else {
        $('#sub_found_container').hide();
        $('#absence_sub_found').val('');
      }
    });
  });

  $('#absence_members_email_1').on('change', function() {
    var performanceSetId = $('#absence_performance_set_dates_performance_set_id').val();
    var member_email_address = $('#absence_members_email_1').val();
    $.get('../../members/requires_sub_name?member_email=' + member_email_address + '&performance_set_id=' + performanceSetId).then(function(response) {
      if (response === true) {
        $('#sub_found_container').show();
      } else {
        $('#sub_found_container').hide();
        $('#absence_sub_found').val('');
      }
    });
  });

  // For MemberSet#new page
  $('.bigForm #member_set_performance_set_id').on('change', function() {
    setInstrumentsForSelection('#member_set\\[new_performance_set_instrument_id\\]', null, false, 'performance_set');
  });

  $('.bigForm #member_set\\[new_performance_set_instrument_id\\]').on('change', function() {
    checkInstrumentOptInStatus('#member_set\\[new_performance_set_instrument_id\\]', 'performance_set');
  });

  // For MemberCommunityNight#new page
  $('.bigFormCommunityNight #member_community_night_community_night_id').on('change', function() {
    setInstrumentsForSelection('#member_community_night\\[new_performance_set_instrument_id\\]', null, false, 'community_night');
  });

  $('.bigFormCommunityNight #member_set\\[new_performance_set_instrument_id\\]').on('change', function() {
    checkInstrumentOptInStatus('member_community_night\\[new_performance_set_instrument_id\\]', 'community_night');
  });

  // For Member#signup page
  $('.bigForm #member_set_performance_set_id').on('change', function() {
    setInstrumentsForSelection('#member_set\\[new_performance_set_instrument_id\\]', null, false, 'performance_set');
  });

  // For member signup page
  $('#memberSignupFormFirstName, #memberSignupFormLastName, #memberSignupFormEmail1, #memberSignupFormIntroduction').on('change', function() {
    if ($('#memberSignupFormFirstName').val().trim().length > 0 &&
        $('#memberSignupFormLastName').val().trim().length > 0 &&
        $('#memberSignupFormEmail1').val().trim().length > 0 &&
        $('#memberSignupFormIntroduction').val().trim().length > 0) {
      $('#submit_form_button').prop('disabled', false);
    } else {
      $('#submit_form_button').prop('disabled', true);
    }
  });

  // For Emails page
  $('#email_type_selector').on('change', function(ev) {
    if (!window.auto_loading) {
      $('#member_set_performance_set_id').val([]).change;
      $('#member_set_ensemble_id').val([]).change;
    }
    emailTypeSelected(ev.target.value);
  });

  $('#member_set_performance_set_id').on('change', function() {
    $('#email_for_step_three').show();
    if (!window.auto_loading) {
      $('#emailMemberStatusSelector').val([]).change;
      $('#emailMemberInstrumentSelector').val([]).change;
    }
    setInstrumentsForSelection('#emailMemberInstrumentSelector', null, true, 'performance_set');
  });

  $('#member_set_ensemble_id').on('change', function() {
    if (!window.auto_loading) {
      $('#emailMemberStatusSelector').val([]).change;
      $('#emailMemberInstrumentSelector').val([]).change;
    }
  });

  $('#email_for_step_three').on('change', function() {
    $('#email_for_step_four').show();
  });

  $("[class^='delAttach']").bind('ajax:success', function() {
    $(this).closest('div').html('Removed');
  });

  // Get email recipients
  $(document).on('change', '#emailFilter select', function() {
    if(!window.auto_loading) {
      updateEmailRecipients();
    }
  });

  $('#emailMemberInstrumentSelector').chosen({
    width: "300px"
  });

  // For opt in overlay
  $('#optInYes').on('click', function() {
    $('#bigFormOverlay').hide();
    $('.clearOut').removeClass('clearOut');
  })

  if (typeof(isNew) !== "undefined") {
    $('a[id^=removeMemberSet]').hide();
    $('a[id^=removeMemberInstrument]').hide();
  }
};

// also in rails, but lowercased and with V1 and V2 broken out
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
    "Harp",
    "Violin",
    "Viola",
    "Cello",
    "String Bass"
  ];

var instrumentsWithSplitViolins = instruments.concat(["Violin 1", "Violin 2"]).filter(function(e) { return e !== 'Violin' });

function attachAC(id, splitViolins) {
  $(id).autoComplete({
    minChars: 1,
    source: function(term, suggest) {
      term = term.toLowerCase();
      var choices = splitViolins ? instrumentsWithSplitViolins : instruments;
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

function setInstrumentsForSelection(instrumentSelectorId, functionToCall, includeConductor, type) {
  var rehearsalSel = $(instrumentSelectorId);
  var newOptions = "";
  if (type === 'global') {
    var instrumentableId = -1;
  } else {
    var instrumentableId = $('#member_set_performance_set_id').val();
  }
  if (type === 'performance_set' || type === 'global') {
    $.get('../../performance_set_instruments/?performance_set_id=' + instrumentableId + '&include_conductor=' + includeConductor).then(function(response) {
      console.log(response);
      $.each(response, function(instrument) {
        var inst = response[instrument].instrument;
        newOptions += '<option value="' + response[instrument].instrument.toLowerCase() + '">' + inst.toLowerCase() + '</option>';
      });
      $('#opt_in_button').prop('disabled', false);
      $('#opt_in_button').val('Opt Into ' + $('#member_set_performance_set_id option:selected').text());
      rehearsalSel.empty().append($(newOptions));
      $('.performance_set_opt_in_message').hide();
      $('#performance_set_opt_in_message_' + instrumentableId).show();
      if (instrumentSelectorId === "#emailMemberInstrumentSelector") {
        $('.startHidden').show();
        $(instrumentSelectorId).trigger('chosen:updated');
      } else {
        rehearsalSel.prop('disabled', false);
      }
      checkInstrumentOptInStatus(instrumentSelectorId, type);

      if(functionToCall) {
        functionToCall();
      }
    });
  } else if (type === 'community_night') {
    instrumentableId = $('#member_community_night_community_night_id').val();
    $.get('../../community_night_instruments/?community_night_id=' + instrumentableId + '&include_conductor=' + includeConductor).then(function(response) {
      $.each(response, function(instrument) {
        var inst = response[instrument].instrument;
        newOptions += '<option value="' + response[instrument].instrument.toLowerCase() + '">' + inst.toLowerCase() + '</option>';
      });
      $('#opt_in_button').prop('disabled', false);
      $('#opt_in_button').val('Opt Into ' + $('#member_set_performance_set_id option:selected').text());
      rehearsalSel.empty().append($(newOptions));
      $('.performance_set_opt_in_message').hide();
      $('#performance_set_opt_in_message_' + instrumentableId).show();
      if (instrumentSelectorId === "#emailMemberInstrumentSelector") {
        $('.startHidden').show();
        $(instrumentSelectorId).trigger('chosen:updated');
      } else {
        rehearsalSel.prop('disabled', false);
      }
      checkInstrumentOptInStatus(instrumentSelectorId, type);

      if(functionToCall) {
        functionToCall();
      }
    });
  }
}

function checkInstrumentOptInStatus(instrumentSelectorId, type) {
  var instrumentableId = $('#member_set_performance_set_id').val();
  var instrument = $(instrumentSelectorId).val();
  if (type === 'performance_set') {
    $.get('../performance_sets/' + instrumentableId + '/check_instrument_limit?instrument=' + instrument)
      .then(function(response) {
        if (response.status == "over_limit") {
          $('.performance_set_inst_limit_message').show();
          $('.over_limit').show();
          $('#instrument_specified').html(instrument);
          $('#instrument_specified_2').html(instrument);
          $('.standby_only').hide();
          $('#opt_in_button').prop('disabled', true);
        } else if (response.status == "standby_only") {
          $('.performance_set_inst_limit_message').show();
          $('.over_limit').hide();
          $('#instrument_specified').html(instrument);
          $('#instrument_specified_2').html(instrument);
          $('.standby_only').show();
          $('#opt_in_button').prop('disabled', false);
        } else if (response.status == "ok") {
          $('.performance_set_inst_limit_message').hide();
          $('#opt_in_button').prop('disabled', false);
        }
      }).fail(function (err) { console.log("ERR", err); });
  } else if (type === 'community_night') {
    instrumentableId = $('#member_community_night_community_night_id').val();
    $.get('../community_nights/' + instrumentableId + '/check_instrument_limit?instrument=' + instrument)
    .then(function(response) {
      if (response.status == "over_limit") {
        $('.performance_set_inst_limit_message').show();
        $('.over_limit').show();
        $('#instrument_specified').html(instrument);
        $('#instrument_specified_2').html(instrument);
        $('.standby_only').hide();
        $('#opt_in_button').prop('disabled', true);
      } else if (response.status == "ok") {
        $('.performance_set_inst_limit_message').hide();
        $('#opt_in_button').prop('disabled', false);
      }
    }).fail(function (err) { console.log("ERR", err); });
  }
}

// Email (set/ensemble selector) form functionality
function emailTypeSelected(typeId) {
  if (typeId == 0) {
    $('#emailForm #member_set_ensemble_id').val([]);
    $('#status_perf_set').show();
    $('#status_ensemble').hide();
    $('#instruments_ensemble').hide();
    $('#instruments_perf_set').show();
    $('#email_for_step_two_ensembles').hide();
    $('#email_for_step_two_perf_sets').show();
    $('#email_for_step_three').hide();
    $('#email_for_step_four').hide();
    $('#email_for_step_two_all').hide();
    $('#email_for_step_two_chamber').hide();
  } else if (typeId == 1) {
    $('#emailForm #member_set_performance_set_id').val([]);
    $('#status_perf_set').hide();
    $('#status_ensemble').show();
    $('#instruments_ensemble').show();
    $('#instruments_perf_set').hide();
    $('#email_for_step_two_ensembles').show();
    $('#email_for_step_two_perf_sets').hide();
    $('#email_for_step_three').hide();
    $('#email_for_step_four').hide();
    $('#email_for_step_two_all').hide();
    $('#email_for_step_two_chamber').hide();
  } else if (typeId == 2) {
    $('#emailForm #member_set_performance_set_id').val([]);
    $('#status_perf_set').hide();
    $('#status_ensemble').hide();
    $('#instruments_ensemble').hide();
    $('#instruments_perf_set').hide();
    $('#email_for_step_two_ensembles').hide();
    $('#email_for_step_two_perf_sets').hide();
    $('#email_for_step_three').hide();
    $('#email_for_step_four').hide();
    $('#email_for_step_two_all').show();
    $('#email_for_step_two_chamber').hide();
  } else if (typeId == 3) {
    $('#emailForm #member_set_performance_set_id').val([]);
    $('#status_perf_set').hide();
    $('#status_ensemble').hide();
    $('#instruments_ensemble').hide();
    $('#instruments_perf_set').hide();
    $('#email_for_step_two_ensembles').hide();
    $('#email_for_step_two_perf_sets').hide();
    $('#email_for_step_three').hide();
    $('#email_for_step_four').show();
    $('#email_for_step_two_all').hide();
    $('#email_for_step_two_chamber').show();
    setInstrumentsForSelection('#emailMemberInstrumentSelector', null, true, 'global')
  }
}

function updateEmailRecipients() {
  var ensemble_search = false;
  var perf_set_search = false;
  var chamber_search = false;
  if ($('#member_set_ensemble_id').val() !== null && $('#member_set_ensemble_id').val() !== "") {
    ensemble_search = true;
  } else if ($('#member_set_performance_set_id').val() !== null && $('#member_set_ensemble_id').val() !== "") {
    perf_set_search = true;
  } else if ($('#email_type_selector').val() == '3') {
    chamber_search = true;
  }

  if ($('#member_set_ensemble_id').val() !== null ||
      ($('#emailMemberStatusSelector').val() !== null && $('#member_set_performance_set_id').val() !== null) ||
      $('#email_type_selector').val() === "2" || $('#email_type_selector').val() === "3") {
    $('#roster').html("<i>Working...</i>");
  } else if ($('#member_set_performance_set_id').val() !== null) {
    $('#roster').html("<i>Please select a status so that member list can show here</i>");
    return;
  } else {
    $('#roster').html("");
    return;
  }

  var queryString;
  if (ensemble_search) {
    queryString = 'ensemble_id=' + $('#member_set_ensemble_id').val();
    queryString += '&status=3';
  } else if (perf_set_search) {
    queryString = 'performance_set_id=' + $('#member_set_performance_set_id').val();
    queryString += '&status=' + $('#emailMemberStatusSelector').val();
  } else if (chamber_search) {
    queryString = 'chamber=true';
  } else {
    queryString = 'all=true';
  }

  if ($('#emailMemberInstrumentSelector').val() != "all") {
    queryString += '&instruments=' + $('#emailMemberInstrumentSelector').val();
  }
  $.get('../../members/get_filtered_member_info?' + queryString).then(function(response) {
    var memberListByInst = {};
    $.each(response, function(i, member_set) {
      if (chamber_search) {
        var member = member_set;
      } else {
        var member = member_set.member;
      }
      var memberInsts = member.member_instruments;
      var instrument;
      if (chamber_search) {
        instrument = "None Listed"
        member.member_instruments.map(function(mi) {
          if (mi && $('#emailMemberInstrumentSelector').val()) {
            if ($('#emailMemberInstrumentSelector').val().indexOf(mi.instrument.toLowerCase()) > -1) {
              instrument = mi.instrument
            }
          } else if (mi) {
            instrument = "Any"
          }
        })
      } else {
        $.each(memberInsts, function(i, mi) {
          if (member_set.set_member_instruments[0] && member_set.set_member_instruments[0].variant != null) {
            instrument = member_set.set_member_instruments[0].variant
          } else if (member_set.set_member_instruments[0] && member_set.set_member_instruments[0].member_instrument_id === mi.id) {
            instrument = mi.instrument;
          }
        });
      }
      if (memberListByInst.hasOwnProperty(instrument)) {
        memberListByInst[instrument].push(member.first_name + " " + member.last_name);
      } else {
        memberListByInst[instrument] = [member.first_name + " " + member.last_name]
      }
      memberListByInst[instrument] = memberListByInst[instrument].filter(function(v,i,self) { return self.indexOf(v) === i })
    });
    var out = "";
    var orderedKeys = Object.keys(memberListByInst).sort();
    var memberCount = 0;
    var memberNameList = [];
    $.each(orderedKeys, function(_, instName) {
      var members = memberListByInst[instName];
      out += "<b>" + instName.charAt(0).toUpperCase() + instName.slice(1) + " (" + members.length + ")</b><br>";
      memberNameList = memberNameList.concat(members);
      out += members.join(", ");
      out += "<br><br>"
    })
    memberCount = memberNameList.filter(function(v,i,self) { return self.indexOf(v) === i }).length
    $('#roster').html("<i>" + memberCount + " members being emailed.<br><br>" + out + "</i>");
    if (memberCount > 0) {
      $('#email_preview_submit_button').prop('disabled', false);
    } else {
      $('#email_preview_submit_button').prop('disabled', true);
    }
  });
}

$(document).ready(loadStuff);
