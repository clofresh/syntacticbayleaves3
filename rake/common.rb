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