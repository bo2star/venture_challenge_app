module ApplicationHelper

  def nav_item(path, options = {}, &block)
    controller = options.delete(:controller)

    is_active = if controller
      params[:controller] == controller
    else
      current_page?(path)
    end

    klass =  is_active ? 'active' : ''

    content_tag(:li, class: klass) do
      link_to(path, options, &block)
    end
  end

  def nav_pill_item(path, options = {}, &block)
    klass = current_page?(path) ? 'active' : ''

    content_tag(:li, class: klass) do
      link_to(path, options, &block)
    end
  end

  def json_for(target, options = {})
    options[:url_options] ||= url_options
    target.active_model_serializer.new(target, options).to_json
  end

  def leaderboard_chart(competition)
    date_range = competition.elapsed_date_range
    teams = competition.teams_by_points

    values_list = teams.map { |t| t.daily_points.cumulative_over(date_range) }

    team_data = teams.map { |t| {name: t.name, color: t.color} }

    data = {
      'values-list' => values_list.to_json,
      'teams' => team_data.to_json,
      'dates' => date_range.to_a.to_json
    }

    content_tag(:div, '', id: 'points-chart' , data: data)
  end

  def team_chart(id, team, metric)
    data = {
      values: metric.cumulative_over(team.report_range),
      dates: team.report_range,
      color: team.color
    }

    content_tag(:div, '', class: 'graph', id: id, data: data)
  end

  def absolute_url(path)
    if path
      path.start_with?('http') ? path : "http://#{path}"
    end
  end

  def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
  end

  def track_browser_user(user, user_keys={})
    @browser_user = user
    keys = user_keys.with_indifferent_access
    @browser_user_keys = {
      'name'        => keys.delete('name')  { user.name },
      'email'       => keys.delete('email') { user.email },
      'signup_date' => keys.delete('signup_date') { user.created_at }
    }
    if user.class == Student && user.team.present?
      additional_keys = {
        'competition'   => keys.delete('competition') { user.competition.id },
        'team'          => keys.delete('team') { user.team.id },
        'instructor'    => keys.delete('instructor') { user.competition.instructor.name },
        'instructor_id' => keys.delete('instructor_id') { user.competition.instructor.id }
      }
      @browser_user_keys.merge!(additional_keys)
    end
    @browser_user_keys.update keys

  end

  # Event tracking helper for Mixpanel/Segment to add tracking code on page load
  #
  # @param [String] event Unique name identifying the page
  # @param [Hash] event_keys custom keys attached to the page event
  #
  def track_browser_page(user, event, event_keys={})
    raise "Already tracked browser page from #{@tracked_browser_page}" if @tracked_browser_page
    return false unless Rails.env.production?
    track_browser_user(user) unless @browser_user
    code = ("analytics.identify('#{@browser_user.id}', #{@browser_user_keys.to_json});" \
            "analytics.track('#{j event}', #{event_keys.to_json});").html_safe
    content_for :scripts, code
    @tracked_browser_page = caller[0]
    true
  end

  def track_form(user, event, event_keys={})
    # return false unless Rails.env.production?
    track_browser_user(user)
    code = ("var forms = $('form');" \
            "analytics.identify('#{@browser_user.id}', #{@browser_user_keys.to_json});" \
            "analytics.trackForm(forms, '#{j event}', #{event_keys.to_json});").html_safe
    content_for :scripts, code

  end

  def track_link(user, links, event)
    # return false unless Rails.env.production?
    track_browser_user(user)
    code = ("var links = $('[#{j links}]');" \
            "analytics.identify('#{@browser_user.id}', #{@browser_user_keys.to_json});" \
            "analytics.trackLink(links, '#{j event}', function (link) {
              return {
                action : link.getAttribute('#{j links}')
              }
            });").html_safe
    content_for :scripts, code
  end

end
