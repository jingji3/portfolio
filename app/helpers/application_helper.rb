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

  # サイドバーの状態管理
  def sidebar_collapsed?
    cookies[:sidebar_collapsed] == 'true'
  end

  def sidebar_width_class
    sidebar_collapsed? ? 'w-16' : 'w-52'
  end

  def main_content_margin_class
    sidebar_collapsed? ? 'lg:ml-16' : 'lg:ml-52'
  end
end
