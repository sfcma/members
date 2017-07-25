require 'csv'
require 'json'

# types of surveys
SURVEY_TYPE_CONDUCTOR = 0
SURVEY_TYPE_CONCERTMASTER = 1

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

# questions


def build_questions_array_conductor(group_name)
  questions = []
  # 7 is free-text
  # 9 is free-text
  # 8 is how-much string
  response_ar = Array.new(10) { |i| if (i == 7 || i == 9) then []; elsif i == 8 then Array.new(4) { 0 }; else Array.new(6) { 0 }; end }

  # question types:
  # 1 is 1-5 scale
  # 2 is the "how much" scale
  # 3 is free-text corresponding to "why_details" hash passed in
  # 4 is free-text corresponding to "feedback_details" hash passed in
  conductor_questions = [
    ['The Conductor makes me feel welcome in the orchestra, without regard to my musical skill level', 1],
    ['The feedback and guidance the Conductor provides is constructive and appropriate relative to my skill level', 1],
    ["Music selection is appropriate for the group's skill level and number of rehearsals", 1],
    ['Full-orchestra rehearsals are well-organized and my time is used effectively', 1],
    ['The Conductor is musically prepared', 1],
    ['I enjoy performing in the concerts', 1],
    ["My musical skills have improved by being a part of #{group_name}", 1],
    ["Why do you play with #{group_name}?", 3],
    ["How much has the Conductor supported the reasons you play with #{group_name}?", 2],
    ['Please include any additional feedback on the Conductor that is not covered by the questions above.', 4],
  ]

  return [conductor_questions, response_ar]
end

def build_graph_source_data(data, survey_type, questions, first_details, second_details)
  if (survey_type == SURVEY_TYPE_CONDUCTOR)
    avg_per_q = Array.new(10)
    free_text = Array.new(10) { |i| [] }
    fav_unfav_percent = Array.new(10) { |i| [] }
    enum_percent = Array.new(10) { |i| Hash.new() }
    data.each_with_index do |response, i|
      puts questions[i][1]
      if questions[i][1] == 0

        free_text[i] = data[i]
      elsif questions[i][1] == 1
        # don't include the "don't care" when computing averages
        response_count_for_avg = data[i].inject(:+) - data[i][0]
        # total is explicit from those who answered this question, not total responders to survey as a whole
        total = data[i][1] + (data[i][2] * 2) + (data[i][3] * 3) + (data[i][4] * 4) + (data[i][5] * 5)
        avg_per_q[i] = total.to_f / response_count_for_avg.to_f

        response_count_for_fav_unfav= data[i].inject(:+)
        # favorte: "agree" and "strongly agree"
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
        enum_percent[i] = first_details
        free_text[i][0] = questions[i][0]
        free_text[i][1] = data[i] ? data[i].join("<br>") : nil
      elsif questions[i][1] == 4
        enum_percent[i] = second_details
        free_text[i][0] = questions[i][0]
        free_text[i][1] = data[i] ? data[i].join("<br>") : nil
      end
    end
    [avg_per_q, fav_unfav_percent, enum_percent, free_text]
  end
end


def parse_csv(input_data, survey_type, group_name, survey_title)
  @survey_title = survey_title
  graph_source_data = []
  questions = []
  response_ar = []
  input_data.each_with_index do |filename_and_details, i|
    file_contents = File.open(filename_and_details[0], 'rb').read
    raw_csv_data = CSV.parse(file_contents)
    first_details = filename_and_details[1]
    second_details = filename_and_details[2]

    if survey_type == SURVEY_TYPE_CONDUCTOR
      info = build_questions_array_conductor(group_name)
    end

    response_ar.push(info[1])
    questions.push(info[0])
    raw_csv_data.each_with_index do |response, x|
      response.each_with_index do |q, j|
        if questions[i][j][1] == 1
          q_num = agree_string_to_num(q)
          response_ar[i][j][q_num] += 1
        elsif questions[i][j][1] == 2
          q_num = how_much_string_to_num(q)
          response_ar[i][j][q_num] += 1
        elsif questions[i][j][1] == 3 || questions[i][j][1] == 4
          response_ar[i][j].push(q)
        end
      end
    end

    @n = raw_csv_data.length
    if survey_type == SURVEY_TYPE_CONDUCTOR
      response_ar[i][7], response_ar[i][8] = response_ar[i][8], response_ar[i][7]
      questions[i][7], questions[i][8] = questions[i][8], questions[i][7]
    end

    graph_source_data.push(build_graph_source_data(response_ar[i], survey_type, questions[i], first_details, second_details))
  end
  File.write('out.html', html_output(graph_source_data[0], questions[0]))
  puts "DONE"
end

def generate_graphs(graph_source_data, questions)
  graphs = []
  graph_source_data[0].each_with_index do |_, i|
    puts " -- #{i} #{questions[i][1]}"
    if questions[i][1] == 1
      graphs << "var ctg#{i} = document.getElementById('ctg#{i}');
  var myChart#{i} = new Chart(ctg#{i}, {
    type: 'bar',
    data: {
      labels: ['2016-17'],
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
    elsif questions[i][1] == 3 || questions[i][1] == 4
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

def generate_canvas_for_question(graph_source_data, questions)
  out = []
  #questions[7], questions[8] = questions[8], questions[7]
  puts questions.inspect
  questions.each_with_index do |q, i|
    out << "<div class='div#{q[1]}' style='border: 1px solid #eee; flex-direction: column; padding: 5px;'><h3>#{q[0]}</h3><br />"
    if q[1] == 1
      out << "<canvas id='ctg#{i}' width='100px' height='150px'></canvas>  <canvas id='ctg#{i}p' width='200px' height='150px'></canvas>"
    elsif q[1] == 2
      out << "<canvas id='ctg#{i}p' width='400px' height='150px'></canvas>"
    elsif q[1] == 3 || q[1] == 4
      out << "<canvas id='ctg#{i}p' width='800px' height='150px'></canvas>"
    end
    out << "</div>"
    if i == 7
      out << "<div style='height: 100px;'></div>"
    end
  end
  #questions[7], questions[8] = questions[8], questions[7]
  out.join("\n")
end


def html_output(graph_source_data, questions)
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
  .flexbox-container div { width: 45%; }
  .flexbox-container div.div3, .flexbox-container div.div4 { width: 100%; }
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
    #{generate_canvas_for_question(graph_source_data, questions)}
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

