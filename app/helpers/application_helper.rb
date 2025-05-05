module ApplicationHelper
  def version_display(date)
    case date
    when Date.new(2025, 3, 26)..Date.new(2025, 5, 6)
      'Ver5.5'
    else
      '最新Ver'
    end
  end

  def date_with_version(date)
    formatted_date = time_ago_in_words(date)
    version = version_display(date.to_date)
    "#{formatted_date}前 / #{version}"
  end
end
