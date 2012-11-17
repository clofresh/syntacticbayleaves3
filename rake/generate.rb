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
    config = get_config
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
    config = get_config

    content = Dir.glob("content/posts/*.html").sort.reverse.map do |post_file|
      File.open(post_file).read
    end.join("\n")

    File.open("build/index.html", "w").write template.result(binding)
  end

  desc "Generates the rss feed"
  task :rss => ["build"] do
    template = ERB.new(File.open("content/layout/shell.rss.erb").read)
    last_build_date = DateTime.now.strftime "%a, %d %b %Y %T GMT"
    pub_date = DateTime.new
    ttl = 60 # minutes
    content = Posts.all.map do |post_file|
      post = Posts.parse_post post_file
      post_date = post[:date]
      pub_date = [post_date, pub_date].max
      post[:date] = post_date.strftime "%a, %d %b %Y %T GMT"
      post
    end
    pub_date = pub_date.strftime "%a, %d %b %Y %T GMT"

    File.open("build/index.rss.xml", "w").write template.result(binding)
  end

  desc "Generates the Google verification file"
  task :google_verification => ["build"] do
    sh "cp content/layout/google847fc09924ef9dd8.html build/"
  end

  desc "Generates the sitemap"
  task :sitemap => [:google_verification, "build"] do
    last_date = Date.new
    content = Posts.all.map do |post_file|
      post = Posts.parse_post post_file
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
