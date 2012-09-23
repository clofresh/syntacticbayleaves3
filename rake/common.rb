def domain
  ENV["BLOG_S3_BUCKET"]
end

def base_url
  "http://#{domain}/"
end
