module ApplicationHelper
  def us_states
    [
      %w(Alabama AL),
      %w(Alaska AK),
      %w(Arizona AZ),
      %w(Arkansas AR),
      %w(California CA),
      %w(Colorado CO),
      %w(Connecticut CT),
      %w(Delaware DE),
      ['District of Columbia', 'DC'],
      %w(Florida FL),
      %w(Georgia GA),
      %w(Hawaii HI),
      %w(Idaho ID),
      %w(Illinois IL),
      %w(Indiana IN),
      %w(Iowa IA),
      %w(Kansas KS),
      %w(Kentucky KY),
      %w(Louisiana LA),
      %w(Maine ME),
      %w(Maryland MD),
      %w(Massachusetts MA),
      %w(Michigan MI),
      %w(Minnesota MN),
      %w(Mississippi MS),
      %w(Missouri MO),
      %w(Montana MT),
      %w(Nebraska NE),
      %w(Nevada NV),
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      %w(Ohio OH),
      %w(Oklahoma OK),
      %w(Oregon OR),
      %w(Pennsylvania PA),
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      %w(Tennessee TN),
      %w(Texas TX),
      %w(Utah UT),
      %w(Vermont VT),
      %w(Virginia VA),
      %w(Washington WA),
      ['West Virginia', 'WV'],
      %w(Wisconsin WI),
      %w(Wyoming WY)
    ]
  end

  SKIP_FIELDS = {
    'MemberInstrument' => ['Member']
  }.freeze

  def generate_audit_string(audit)

    audit_string = []
    if audit.action == 'destroy'
      if audit.user_id
        audit_string << {
          html: "#{User.find(audit.user_id).display_name} destroyed <b>#{audit.auditable_type.underscore.humanize}</b> with values #{audit.audited_changes.inspect} on #{audit.created_at.in_time_zone('Pacific Time (US & Canada)').strftime('%Y-%m-%d %-I:%M %p PT')}<br>".html_safe,
          audit_created_at: audit.created_at.in_time_zone('Pacific Time (US & Canada)')
        }
      else
        audit_string << {
          html: "Logged out user destroyed <b>#{audit.auditable_type.underscore.humanize}</b> with values #{audit.audited_changes.inspect} on #{audit.created_at.in_time_zone('Pacific Time (US & Canada)').strftime('%Y-%m-%d %-I:%M %p PT')}<br>".html_safe,
          audit_created_at: audit.created_at.in_time_zone('Pacific Time (US & Canada)')
        }
      end
    else
      audit.audited_changes.each do |field, change|
        if change.is_a?(Array)
          if !change[0] && field != 'playing_status'
            change_text = "as <b>#{change[1]}</b>"
            verb = 'filled in'
          elsif field == 'playing_status'
            change_text = "from <b>Untriaged</b> to <b>#{change[1]}</b>"
            verb = 'changed'
          else
            change_text = "from <b>#{change[0]}</b> to <b>#{change[1]}</b>"
            verb = 'changed'
          end
        else
          change_text = "to <b>#{change}</b>"
          verb = 'added'
        end
        if SKIP_FIELDS.keys.include?(audit.auditable_type) && SKIP_FIELDS[audit.auditable_type] && SKIP_FIELDS[audit.auditable_type].include?(field.humanize)
          next
        end
        a_type_string = if audit.auditable_type.underscore.humanize == 'Member'
                          ''
                        else
                          "on <b>#{audit.auditable_type.underscore.humanize}</b>"
                        end
        if audit.user_id
          audit_string << {
            html: "#{User.find(audit.user_id).display_name} #{verb} <b>#{field.humanize.capitalize}</b> #{a_type_string} #{change_text} on #{audit.created_at.in_time_zone('Pacific Time (US & Canada)').strftime('%Y-%m-%d %-I:%M %p PT')}<br>".html_safe,
            audit_created_at: audit.created_at.in_time_zone('Pacific Time (US & Canada)')
          }
        else
          audit_string << {
            html: "UNKNOWN USER destroyed <b>#{audit.auditable_type.underscore.humanize}</b> with values #{audit.audited_changes.inspect} on #{audit.created_at.in_time_zone('Pacific Time (US & Canada)').strftime('%Y-%m-%d %-I:%M %p PT')}<br>".html_safe,
            audit_created_at: audit.created_at.in_time_zone('Pacific Time (US & Canada)')
          }
        end
      end
    end
    audit_string
  end

  def generate_audit_array(obj)
    audit_string = []
    if obj.is_a?(Array)
      obj.each do |inner_obj|
        audit_string += generate_audit_array(inner_obj)
      end
    else
      obj.audits.each do |obj_audit|
        audit_string << generate_audit_string(obj_audit)
      end
    end
    audit_string
  end
end
