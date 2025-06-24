module ApplicationHelper
  # データのバージョン表現
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
    sidebar_collapsed? ? 'md:ml-16' : 'md:ml-52'
  end

  # SEO(OGP用)
  def default_meta_tags
    {
      site: 'GTS',
      title: content_for(:title).presence || 'GENSHIN TEAM SEARCH SHARE',
      reverse: true,
      separator: ' | ',
      description: '原神の最適な編成を検索・共有できるサイト。キャラクター検索で理想のチーム編成を発見し、推しのYouTubeクリエイターの応援もできます!',
      keywords: '原神,最適編成,検索,GENSHIN,Genshin Impact',
      canonical: request.original_url,
      noindex: false,
      icon: [
        { href: image_url('favicon.ico') }
      ],
      # OGP表示
      og: {
        site_name: 'GTS',
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp_sample.png'),
        locale: 'ja_JP',
      },
      # X用
      twitter: {
        card: 'summary', # 小さなOGP　(大きい時はsummary_large_image)
        title: :title,
        description: :description,
        image: image_url('ogp_sample.png'),
      }
    }
  end
end
