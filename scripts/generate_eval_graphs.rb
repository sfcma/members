# encoding: UTF-8

require 'csv'
require 'json'
require 'date'

# ###################################################################
#
# HOW TO USE THIS SCRIPT:
#

# PART ONE

# 1. Download the CSV output from the Google Form
#
# 2. Determine which type of report you are generating. Typically this means 
#    determining which position (conductor, concertmaster) and what is the 
#    audience (the Board or the subject)
#
# 3. Check the questions in the survey against the questions in this script 
#    for that type. Update the questions in this script to match, if necessary. 
#    Look for "SET QUESTIONS HERE"
#
#    Make sure that if you are running a survey type that eliminates some responses,
#    such as the Conductor survey for distribution to the Conductor, you need
#    to remove extraneous data from the CSV file, or you will get an error.
#
# 4. Record the SURVEY TYPE number for the type of report you are generating. 
#    You'll need this later.

# PART TWO

# 5. Review the survey for any free-text questions of question type 3. Question 
#    type 3 will generate a bar graph based on tallied category totals. 
#
# 6. Review the free-text responses. For each question of type 3, summarize and 
#    tally responses by category. 

# PART THREE

# 7. Run the survey using the following command, filling in the variables as 
#    indicated below
#
# ruby -r "generate_eval_graphs.rb" -e "parse_csv [[<A>, <B>]], <C>, <D>, <E>"
#
# <A>: This is the filename of the file exported from Google Forms.  
#
# <B>: This is the tallied, grouped counts for each category of response, that  
#      you compiled in Part Two. It must be formatted as a Ruby object, so: 
#      { 'Category': Count, 'Category': Count }
#
#      For example, for a question "What additional feedback do you have for this conductor?"
#      you might categorize responses in this way:  { 'Positive': 10, 'Negative': 2 }
#
#      Each category name MUST be unique. Empty space category names can be 
#      used as spacers.
#
#      Include one set of responses (inside curly braces) for each question 
#      of Type 3. When there are multiple questions of that type, order the 
#      responses as they are **IN THE OUTPUT**. They should be separated by a comma, 
#      and within the same square brackets as the filename.
#
# <C>: The numeric survey type, as written down in step 3
#
# <D>: The name of the ensemble being surveyed
#
# <E>: The title of the survey results report. This is often the title of the survey itself.
#
#   Sample command:
#
#   ruby -r "generate_eval_graphs.rb" -e "parse_csv [['Civic Conductor Evaluation: 2020-21 Season.csv', \
#   {'Community': 1, 'Repertoire': 8, 'Improve Skill': 5, 'Conductor': 3, 'Performance': 1}, \
#   {'Positive': 10, 'Negative': 3, '': 0, 'Knowledgeable': 3, 'Energy': 5, ' ': 0, 'Community': 2}]], \
#   0, 'Civic', 'Civic 2020-21 Survey Results'"
#
# 8. This command will generate a file in the same folder called "out.html". Open this 
#    in any web browser to view the results. It is recommended to print as a pdf file
#    to distribute -- BEST RESULTS USING CHROME.
#

# ----- END "HOW TO USE THIS SCRIPT" TUTORIAL

# ###################################################################
#
# SET QUESTIONS HERE
#

# Question types:
# 1 is 1-5 scale ("Strongly Agree/Agree/Not Sure/Disagree/Strongly Disagree")
# 2 is the "how much" scale ("A lot/A little bit/Not at all/Not sure")
# 3 is free-text 
# 4 is Yes/Somewhat/No/Not Sure

class SurveyQuestions
  QUESTION_SOURCES = {}
  QUESTION_ORDERS = {}
  QUESTION_REPORT_SPACINGS = {}

  # CONDUCTOR SURVEY, FOR DISTRIBUTION TO CONDUCTOR
  # SURVEY TYPE 0

  SURVEY_TYPE_CONDUCTOR = 0
  QUESTION_SOURCES[SURVEY_TYPE_CONDUCTOR] = Proc.new do |group_name|
    [
      ['The Conductor makes me feel welcome in the orchestra, without regard to my musical skill level', 1],
      ['The feedback and guidance the Conductor provides is constructive and appropriate relative to my skill level', 1],
      ["Music selection is appropriate for the group's skill level and number of rehearsals", 1],
      ['Full-orchestra rehearsals are well-organized and my time is used effectively', 1],
      ['The Conductor is musically prepared', 1],
      ['I enjoy performing in the concerts', 1],
      ["My musical skills have improved by being a part of #{group_name}", 1],
      ["I felt adequately prepared for the #{group_name} Concert", 1],
      ["I would be interested in returning to play with #{group_name} in the future", 1],
      ["I would recommend playing in #{group_name} to my musician friends (separately from other SFCMA ensembles)", 1],
      ["#{group_name} is a valuable addition to the set of ensembles supported by the SFCMA", 1],
      ["How much has the Conductor supported the reasons you play with #{group_name}?", 2],
      ["Please include any additional feedback you would like to share with the Conductor and Board that is not covered by the questions above.", 3]
    ]
  end
  QUESTION_ORDERS[SURVEY_TYPE_CONDUCTOR] = Proc.new do
    [0,1,2,3,4,5,6,7,8,9,10,11,12]
  end
  # This method is used to add space at the end of page 1, bumping the next question to the top of page 2
  # You can use this to add spacing to the top of any question, but please preview the report before
  # printing if you change this.
  QUESTION_REPORT_SPACINGS[SURVEY_TYPE_CONDUCTOR] = Proc.new do
    { '7': "100px" }
  end
  
  # CONCERTMASTER SURVEY, FOR DISTRIBUTION TO CONCERTMASTER
  # SURVEY TYPE 1

  SURVEY_TYPE_CONCERTMASTER = 1
  QUESTION_SOURCES[SURVEY_TYPE_CONCERTMASTER] = Proc.new do |group_name|
    [
      ['The concertmaster makes me feel welcome in the orchestra, without regard to my musical skill level.', 1],
      ['The feedback and guidance provided by the concertmaster is constructive and appropriate for my skill level.', 1],
      ["Sectional rehearsals are well-organized and my time is used effectively.", 1],
      ['The concertmaster is musically prepared.', 1],
      ['The guidance of the concertmaster helps my musical skills improve.', 1],
      ["What do you feel are the responsibilities of the concertmaster?", 3],
      ["Do you feel the concertmaster is meeting those responsibilities?", 4],
      ["How much has the concertmaster supported the reasons you play with #{group_name}?", 2],
      ['Please include any additional feedback on the concertmaster that is not covered by the questions above.', 3]
    ]
  end
  QUESTION_ORDERS[SURVEY_TYPE_CONCERTMASTER] = Proc.new do
    [0,1,2,3,4,5,6,7,8]
  end
  # This method is used to add space at the end of page 1, bumping the next question to the top of page 2
  # You can use this to add spacing to the top of any question, but please preview the report before
  # printing if you change this.
  QUESTION_REPORT_SPACINGS[SURVEY_TYPE_CONCERTMASTER] = Proc.new do
    { '6': "100px" }
  end

  # CONDUCTOR SURVEY, FOR DISTRIBUTION TO BOARD
  # SURVEY TYPE 2

  SURVEY_TYPE_CONDUCTOR_BOARD = 2
  QUESTION_SOURCES[SURVEY_TYPE_CONDUCTOR_BOARD] = Proc.new do |group_name|
    [
      ['The Conductor makes me feel welcome in the orchestra, without regard to my musical skill level', 1],
      ['The feedback and guidance the Conductor provides is constructive and appropriate relative to my skill level', 1],
      ["Music selection is appropriate for the group's skill level and number of rehearsals", 1],
      ['Full-orchestra rehearsals are well-organized and my time is used effectively', 1],
      ['The Conductor is musically prepared', 1],
      ['I enjoy performing in the concerts', 1],
      ["My musical skills have improved by being a part of #{group_name}", 1],
      ["I felt adequately prepared for the #{group_name} Concert", 1],
      ["I would be interested in returning to play with #{group_name} in the future", 1],
      ["I would recommend playing in #{group_name} to my musician friends (separately from other SFCMA ensembles)", 1],
      ["#{group_name} is a valuable addition to the set of ensembles supported by the SFCMA", 1],
      ["How much has the Conductor supported the reasons you play with #{group_name}?", 2],
      ["What changes, if any, would you make to future sets of #{group_name}?", 3],
      ["Please include any additional feedback you would like to share with the Conductor and Board that is not covered by the questions above.", 3],
      ["Please include any additional feedback you would like to share with the Board that is not covered by the questions above.", 3]
    ]
  end
  QUESTION_ORDERS[SURVEY_TYPE_CONDUCTOR_BOARD] = Proc.new do
    [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]
  end
  # This method is used to add space at the end of page 1, bumping the next question to the top of page 2
  # You can use this to add spacing to the top of any question, but please preview the report before
  # printing if you change this.
  QUESTION_REPORT_SPACINGS[SURVEY_TYPE_CONDUCTOR_BOARD] = Proc.new do
    { '7': "100px" }
  end
end

# ###################################################################
#
# CODE STARTS HERE
#

# Utility methods

def agree_string_to_num(str)
  case str
  when 'Strongly Agree'
    return 5
  when 'Agree'
    return 4
  when 'Disagree'
    2
  when 'Strongly Disagree'
    1
  when "Not Sure / Doesn't Matter"
    return 0
  else
    return 0
  end
end

@how_much_labels = ["Not sure / Doesn't matter", 'Not at all', 'A little bit', 'A lot']

def how_much_string_to_num(str)
  case str
  when 'A lot'
    return 3
  when 'A little bit'
    return 2
  when 'Not at all'
    return 1
  when "Not sure / Doesn't matter"
    return 0
  else
    return 0
  end
end

@yes_no_somewhat_labels = ["Yes", "Somewhat", "No", "Not Sure / Doesn't Matter"]

def yes_no_somewhat_string_to_num(str)
  case str
  when 'Yes'
    return 3
  when 'Somewhat'
    return 2
  when 'No'
    return 1
  when "Not Sure / Doesn't Matter"
    return 0
  else
    return 0
  end
end

@free_text_count = 0


def build_questions_array(group_name, survey_type)
  questions = SurveyQuestions.const_get('QUESTION_SOURCES')[survey_type].call(group_name)

  response_ar = Array.new(questions.length) { |i|
    q_type = questions[i][1]
    case q_type
    when 1
      Array.new(6) { 0 }
    when 2, 4
      Array.new(4) { 0 }
    when 3
      []
    end
  }

  return [questions, response_ar]
end

def build_graph_source_data(data, questions, details)
  avg_per_q = Array.new(questions.length)
  free_text = Array.new(questions.length) { |i| [] }
  fav_unfav_percent = Array.new(questions.length) { |i| [] }
  enum_percent = Array.new(questions.length) { |i| Hash.new() }
  data.each_with_index do |response, i|
    if questions[i][1] == 0
      free_text[i] = data[i]
    elsif questions[i][1] == 1
      # don't include the "don't care" when computing averages
      response_count_for_avg = data[i].inject(:+) - data[i][0]
      # total is explicit from those who answered this question, not total responders to survey as a whole
      total = data[i][1] + (data[i][2] * 2) + (data[i][3] * 3) + (data[i][4] * 4) + (data[i][5] * 5)
      avg_per_q[i] = total.to_f / response_count_for_avg.to_f

      response_count_for_fav_unfav= data[i].inject(:+)
      # favorite: "agree" and "strongly agree"
      fav_unfav_percent[i][0] = (data[i][4] + data[i][5]).to_f / response_count_for_fav_unfav.to_f
      # unfavorable: "disagree" and "strongly disagree"
      fav_unfav_percent[i][1] = (data[i][1] + data[i][2]).to_f / response_count_for_fav_unfav.to_f
      # note that fav + unfav != 100, because "don't care" are included in neither count
    elsif questions[i][1] == 2
      # total is explicit from those who answered this question, not total responders to survey as a whole
      total =  data[i].inject(:+)
      @how_much_labels.each_with_index do |label, j|
        enum_percent[i][label] = data[i][j].to_f / total.to_f
      end
    elsif questions[i][1] == 3
      enum_percent[i] = details[@free_text_count]
      @free_text_count += 1
      free_text[i][0] = questions[i][0]
      free_text[i][1] = data[i] ? data[i].shuffle.join("<br>").force_encoding('UTF-8') : nil
    elsif questions[i][1] == 4
      # total is explicit from those who answered this question, not total responders to survey as a whole
      total =  data[i].inject(:+)
      @yes_no_somewhat_labels.each_with_index do |label, j|
        enum_percent[i][label] = data[i][j].to_f / total.to_f
      end
    end
  end
  [avg_per_q, fav_unfav_percent, enum_percent, free_text]
end


def parse_csv(input_data, survey_type, group_name, survey_title)
  @survey_title = survey_title
  graph_source_data = []
  questions = []
  response_ar = []
  input_data.each_with_index do |filename_and_details, i|
    file_contents = File.open(filename_and_details[0], 'rb').read
    raw_csv_data = CSV.parse(file_contents)
    details = filename_and_details.drop(1)
    first_column_is_timestamp = false
    first_row_is_header = false

    info = build_questions_array(group_name, survey_type)

    response_ar.push(info[1])
    questions.push(info[0])

    # Handle timestamps and column headers
    if raw_csv_data[0][0].downcase == "timestamp"
      first_column_is_timestamp = true
      first_row_is_header = true
    elsif raw_csv_data[0][0].downcase == questions[0][0][0].downcase
      first_row_is_header = true
    else
      begin
        Date.parse(raw_csv_data[0][0])
        first_column_is_timestamp = true
      rescue ArgumentError
        # first column not timestamp
      end
    end

    raw_csv_data.each_with_index do |survey_row, row_num|
      survey_row.each_with_index do |indiv_response, j|
        next if first_column_is_timestamp && j == 0
        next if first_row_is_header && row_num == 0
        
        question_num = first_column_is_timestamp ? j - 1 : j
        if questions[i][question_num][1] == 1
          numeric_response = agree_string_to_num(indiv_response)
          response_ar[i][question_num][numeric_response] += 1
        elsif questions[i][question_num][1] == 2
          numeric_response = how_much_string_to_num(indiv_response)
          response_ar[i][question_num][numeric_response] += 1
        elsif questions[i][question_num][1] == 4
          numeric_response = yes_no_somewhat_string_to_num(indiv_response)
          response_ar[i][question_num][numeric_response] += 1
        elsif questions[i][question_num][1] == 3
          response_ar[i][question_num].push(indiv_response)
        end
      end
    end

    @n = raw_csv_data.length - (first_column_is_timestamp ? 1 : 0)

    # Sort responses by the order used in the reporting
    order = SurveyQuestions.const_get('QUESTION_ORDERS')[survey_type].call

    response_ar[i] = response_ar[i].values_at(*order)
    questions[i] = questions[i].values_at(*order)

    graph_source_data.push(build_graph_source_data(response_ar[i], questions[i], details))
  end
  File.write('out.html', html_output(graph_source_data[0], questions[0], survey_type))
  puts "DONE. Parsed #{@n} responses."
end

def generate_graphs(graph_source_data, questions)
  graphs = []
  graph_source_data[0].each_with_index do |_, i|
    puts "Generated Graph for Question ##{i} of type #{questions[i][1]}"
    if questions[i][1] == 1
      graphs << "var ctg#{i} = document.getElementById('ctg#{i}');
  var myChart#{i} = new Chart(ctg#{i}, {
    type: 'bar',
    data: {
      labels: ['Avg.'],
      datasets: [{
        data: [#{graph_source_data[0][i]}],
        borderWidth: 1
      }]
    },
    options: { scales: {
      yAxes: [{
        ticks: {
          max: 5,
          stepSize: 1
        }
      }],
      xAxes: [{ ticks: { autoSkip: false } }] } }
  });"
      graphs << "var ctg#{i}p = document.getElementById('ctg#{i}p');
  var myChart#{i}p = new Chart(ctg#{i}p, {
    type: 'bar',
    data: {
      labels: ['Favorable', 'Unfavor.'],
      datasets: [{
        data: #{graph_source_data[1][i]},
        borderWidth: 1
      }]
    },
    options: { scales: {
      yAxes: [{
        gridLines: { display: true },
        ticks: {
          callback: function(value, index, values) {
                      return Math.round(value * 100) + '%';
                    }
        }
      }],
      xAxes: [{ gridLines: { display: false }, ticks: { autoSkip: false,  } }] } }
  });"
    elsif questions[i][1] == 2
      graphs << "var ctg#{i}p = document.getElementById('ctg#{i}p');
    var myChart#{i}p = new Chart(ctg#{i}p, {
      type: 'bar',
      data: {
        labels: #{@how_much_labels.reverse},
        datasets: [{
          data: #{graph_source_data[2][i].values.reverse},
          borderWidth: 1
        }]
      },
      options: { scales: {
        yAxes: [{
          gridLines: { display: true },
          ticks: {
            max: 0.8,
            callback: function(value, index, values) {
                        return Math.round(value * 100) + '%';
                      }
          }
        }],
        xAxes: [{
          gridLines: { display: false },
          ticks: {
            callback: function(value, index, values) {
              if (value === \"Not sure / Doesn't matter\") {
                return [\"Not Sure / \",\"Doesn't Matter\"];
              } else { return value; }
            },
            autoSkip: false } }] } }
    });"
  elsif questions[i][1] == 4
    graphs << "var ctg#{i}p = document.getElementById('ctg#{i}p');
    var myChart#{i}p = new Chart(ctg#{i}p, {
      type: 'bar',
      data: {
        labels: #{@yes_no_somewhat_labels},
        datasets: [{
          data: #{graph_source_data[2][i].values.reverse},
          borderWidth: 1
        }]
      },
      options: { scales: {
        yAxes: [{
          gridLines: { display: true },
          ticks: {
            max: 1,
            callback: function(value, index, values) {
                        return Math.round(value * 100) + '%';
                      }
          }
        }],
        xAxes: [{
          gridLines: { display: false },
          ticks: {
            callback: function(value, index, values) {
              if (value === \"Not Sure / Doesn't Matter\") {
                return [\"Not Sure / \",\"Doesn't Matter\"];
              } else { return value; }
            },
            maxRotation: 0,
            minRotation: 0,
            autoSkip: false } }] } }
    });"
    elsif questions[i][1] == 3
      graphs << "var ctg#{i}p = document.getElementById('ctg#{i}p');
      var myChart#{i}p = new Chart(ctg#{i}p, {
        type: 'bar',
        data: {
          labels: #{graph_source_data[2][i].keys.map(&:to_s)},
          datasets: [{
            data: #{graph_source_data[2][i].values},
            borderWidth: 1
          }]
        },
        options: { scales: {

          yAxes: [{ ticks: { display: false, min: 0, max: #{graph_source_data[2][i].values.max}, stepSize: 1 } }],
          xAxes: [{
            ticks: {
              callback: function(value, index, values) {
                if (value.indexOf(' ') > -1) {
                  return value.split(' ');
                } else { return value; }
              },
              maxRotation: 0,
              minRotation: 0,
              autoSkip: false } }] } }
      });"
    end
  end
  graphs.join("\n")
end

def generate_canvas_for_question(graph_source_data, questions, survey_type)
  out = []
  questions.each_with_index do |q, i|
    out << "<div class='div#{q[1]}' style='border: 1px solid #eee; flex-direction: column; padding: 5px;'><h3>#{q[0]}</h3><br />"
    if q[1] == 1
      out << "<canvas id='ctg#{i}' width='100px' height='150px'></canvas>  <canvas id='ctg#{i}p' width='200px' height='150px'></canvas>"
    elsif q[1] == 2 || q[1] == 4
      out << "<canvas id='ctg#{i}p' width='400px' height='150px'></canvas>"
    elsif q[1] == 3
      out << "<canvas id='ctg#{i}p' width='800px' height='150px'></canvas>"
    end
    out << "</div>"
    spacings = SurveyQuestions.const_get('QUESTION_REPORT_SPACINGS')[survey_type].call
    if spacings.has_key?(i.to_s.to_sym)
      out << "<div style='height: #{spacings[i.to_s.to_sym]}; width: 80%'></div>"
    end
  end
  out.join("\n")
end


def html_output(graph_source_data, questions, survey_type)
  return <<END
  <html>
  <head>
  <style>
  .flexbox-container {
    display: flex;
    flex-wrap:wrap;
    flex-direction:row;
    justify-content:flex-start;
    align-items:stretch;
  }
  .flexbox-container div, .flexbox-container div.div4 { width: 45%; }
  .flexbox-container div.div3 { width: 100%; }
  canvas { display: inline-block !important; }
  * { font-family: Helvetica; }
  h3 {
    font-size: 14px;
    margin: 5px 0;
  }
  h1 span {
    font-size: 14px;
    display: block;
    margin: 10px 0 0 0;
  }
  li {
    list-style-type: none;
    margin-top: 3px;
    padding-top: 3px;
    border-top: 1px solid #ddd;
  }
  </style>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.bundle.min.js"></script>
  </head>
  <body>
  <h1>#{@survey_title} <span>#{@n} Responses</span></h1>
  <div class='flexbox-container'>
    #{generate_canvas_for_question(graph_source_data, questions, survey_type)}
  </div>
  <script>
  Chart.defaults.global.responsive = false;
  Chart.defaults.global.tooltips.enabled = false;
  Chart.defaults.global.animation.duration = 1;
  Chart.defaults.global.legend.display = false;
  Chart.defaults.global.layout = {
    padding: {
      top: 10
    }
  };
  Chart.scaleService.updateScaleDefaults('linear', {
    ticks: {
      min: 0.0,
      max: 1.0,
      stepSize: 0.2,
      autoSkip: false
    },
    gridLines: {
      display: false
    }
  });
  g_data = #{JSON.generate(graph_source_data)};

  #{generate_graphs(graph_source_data, questions)}

  // Put labels on charts
  Chart.plugins.register({
    afterDatasetsDraw: function(chart, easing) {
      // To only draw at the end of animation, check for easing === 1
      var ctx = chart.ctx;
      chart.data.datasets.forEach(function (dataset, i) {
        if (ctx.canvas.id.substr(-1) == "p") { } else {
          var meta = chart.getDatasetMeta(i);
          if (!meta.hidden) {
            meta.data.forEach(function(element, index) {
              // Draw the text in black, with the specified font
              ctx.fillStyle = 'rgb(0, 0, 0)';
              var fontSize = 14;
              var fontStyle = 'normal';
              var fontFamily = 'Helvetica Neue';
              ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);
              // Just naively convert to string for now
              var dataString = (Math.round(dataset.data[index] * 100) / 100).toString();
              // Make sure alignment settings are correct
              ctx.textAlign = 'center';
              ctx.textBaseline = 'top';
              var padding = 5;
              var position = element.tooltipPosition();
              ctx.fillText(dataString, position.x, position.y - (fontSize / 2) - padding);
            });
          }
        }
      });
    }
  });

  </script>
  <div>
    #{graph_source_data[3].select { |ft| ft.length > 0 }.map { |ft| "<br><br><b>#{ft[0]}</b><br>#{ft[1].gsub(/(<br>)+/,'<li>')}" }.join("")}
  </div>
  </body>
  </html>


END
end

