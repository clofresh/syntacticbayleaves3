def domain
  ENV["BLOG_S3_BUCKET"]
end

def base_url
  "http://#{domain}/"
end

def get_config
  {
    :site => {
      :name    => "Syntactic Bay Leaves",
      :caption => "Pungent programming, and other topics of note",
      :author  => "Carlo Cabanilla",
      :rss     => "http://feeds.feedburner.com/syntacticbayleaves/fshk"
    },
    :openid => {
      :provider => "https://www.google.com/accounts/o8/ud?source=profiles",
      :local_id => "https://plus.google.com/u/1/107061127726805374925/",
    },
    :google_analytics_id => "UA-4116300-1",
  }
end

module Posts
  require 'nokogiri'

  def self.all()
    Dir.glob("content/posts/*.html").sort.reverse
  end

  def self.parse_post(post_file, current_path = nil)
    current_path = current_path || "/"
    doc = Nokogiri::HTML(File.open(post_file))
    date =  Date.strptime(doc.css("article .date").text.strip, "%a, %b %d, %Y")
    doc.css("article .body img").each do |img|
      img['src'] = full_url img['src'], current_path
    end
    doc.css("article .body a").each do |a|
      a['href'] = full_url a['href'], current_path
    end
    {
      :title => doc.css("article .title").text,
      :body  => doc.css("article .body"),
      :url   => base_url + doc.css("article a.permalink").attribute("href"),
      :date  => date
    }
  end

  def self.full_url(url, current_path)
    if url != nil and url != '' and URI.parse(url).scheme == nil
      if url.start_with? '/'
        base_url.sub(/\/$/, '') + url
      else
        base_url.sub(/\/$/, '') + current_path + url
      end
    else
      url
    end
  end
end
