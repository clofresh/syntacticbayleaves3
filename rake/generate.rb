require 'date'
require 'erb'
require 'uri'

require 'rake/common'

directory "build"
directory "build/posts"
directory "build/img"
directory "build/css"
directory "build/js"

desc "Generates all the assets and content"
task :generate => ["generate:assets", "generate:content"]

namespace :generate do
  desc "Generates all the assets"
  task :assets => [:img, :css, :js]

  desc "Generates all the content"
  task :content => [:posts, :index, :rss, :sitemap, :google_verification, :old]

  desc "Generates the image assets"
  task :img => ["build/img"] do 
    sh "cp assets/img/* build/img/" 
  end 

  desc "Generates the css assets"
  task :css => ["build/css"] do 
    sh "cp assets/css/*.min.css build/css/" 
    sh "cp assets/css/syntacticbayleaves.css build/css/" 
  end 

  desc "Generates the javascript assets"
  task :js => ["build/js"] do 
    sh "cp assets/js/*.min.js build/js/" 
    sh "cp assets/js/syntacticbayleaves.js build/js/" 
  end 

  desc "Generates the individual post files"
  task :posts => ["build", "build/posts"] do
    template = ERB.new(File.open("content/layout/shell.html.erb").read)

    Dir.glob("content/posts/*.html").each do |post_file|
      content = File.open(post_file).read
      generated_file = "build/" + File.basename(post_file)
      File.open(generated_file, "w") do |f|
        f.write template.result(binding)
      end
    end


  end

  desc "Generates the blog home page"
  task :index => ["build"]  do
    template = ERB.new(File.open("content/layout/shell.html.erb").read)

    content = Dir.glob("content/posts/*.html").sort.reverse.map do |post_file|
      File.open(post_file).read
    end.join("\n")

    File.open("build/index.html", "w").write template.result(binding)
  end

  def parse_posts(current_path)
    require 'nokogiri'

    def full_url(url, current_path)
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

    Dir.glob("content/posts/*.html").sort.reverse.map do |post_file|
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
  end

  desc "Generates the rss feed"
  task :rss => ["build"] do
    template = ERB.new(File.open("content/layout/shell.rss.erb").read)
    last_build_date = DateTime.now.strftime "%a, %d %b %Y %T GMT"
    pub_date = last_build_date
    ttl = 60 # minutes
    content = parse_posts('/').map do |post|
      post[:date] = post[:date].strftime("%a, %d %b %Y %T GMT")
      post
    end

    File.open("build/index.rss.xml", "w").write template.result(binding)
  end

  desc "Generates the Google verification file"
  task :google_verification => ["build"] do
    sh "cp content/layout/google847fc09924ef9dd8.html build/"
  end

  desc "Generates the sitemap"
  task :sitemap => [:google_verification, "build"] do
    last_date = Date.new
    content = parse_posts('/').map do |post|
      last_date = [last_date, post[:date]].max
      post.update({
        :changefreq => "never",
        :priority   => "0.6",
        :date       => post[:date].strftime("%Y-%m-%d")
      })
    end


    content << {
          :url    => base_url,
          :date       => last_date.strftime("%Y-%m-%d"),
          :changefreq => "weekly",
          :priority   => "0.3"
        }
    
    template = ERB.new(File.open("content/layout/sitemap.xml.erb").read)
    File.open("build/sitemap.xml", "w").write template.result(binding)
  end

  desc "Generates the old content from previous blogs"
  task :old => ["build"] do
    sh "cp -r content/old/* build/"
  end

end

desc "Starts a new post"
task :new_post do
  post_id = "%08d" % (Dir.glob('content/posts/*.html').inject(0) do |max, file| 
    [max, File.basename(file, ".html").to_i].max
  end + 1) 
  date = Date.today.strftime "%a, %b %-d, %Y"
  post_path = "#{post_id}.html"

  template = ERB.new(File.open("content/layout/post.html.erb").read)
  new_post = template.result(binding)

  file_path = "content/posts/" + post_path
  puts file_path
  File.open(file_path, "w") { |io| io.write(new_post) }
end

desc "Clears the generate files"
task :clean do
  rm_rf "build/*"
end
