class CompetitionDecorator < Draper::Decorator

  delegate_all

  def date_range
    if start_date && end_date
      format_date(start_date) + ' &mdash; ' + format_date(end_date)
    else
      '&mdash;'
    end.html_safe
  end

  def join_url
    h.join_url(token, subdomain: 'app')
  end

  private

    def format_date(date)
      date.strftime('%B %e, %Y')
    end

end