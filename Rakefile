require 'rubygems'
require 'bundler/setup'
require 'erb'
require 'date'
require 'fileutils'

def domain
	ENV["BLOG_S3_BUCKET"]
end

def base_url
	"http://#{domain}/"
end

task :default => [:clean, :generate]

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

	def parse_posts
		require 'nokogiri'

		Dir.glob("content/posts/*.html").sort.reverse.map do |post_file|
			doc = Nokogiri::HTML(File.open(post_file))
			date =  Date.strptime(doc.css("article .date").text.strip, "%a, %b %d, %Y")
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
		content = parse_posts.map do |post|
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
		content = parse_posts.map do |post|
			last_date = [last_date, post[:date]].max
			post.update({
				:changefreq => "never",
				:priority   => "0.6",
				:date 		=> post[:date].strftime("%Y-%m-%d")
			})
		end


		content << {
					:url	=> base_url,
					:date 		=> last_date.strftime("%Y-%m-%d"),
					:changefreq	=> "weekly",
					:priority	=> "0.3"
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


namespace :server do
	http_server = "python -m SimpleHTTPServer"

	desc "Starts the dev server"
	task :start => [:stop] do |t|
		cd "build" do 
			sh "#{http_server} >> ../http.log 2>&1 &"
		end
	end

	desc "Stops the dev server"
	task :stop do |t|
		begin
			sh "pkill -f '#{http_server}'"
		rescue Exception => e
			
		end
	end
end

desc "Publishes the generate files to S3"
task :publish do
	require 'aws/s3'
	require 'md5'
	include AWS::S3

	# This is an extension to S3Object that supports the emerging 'standard' for virtual folders on S3.
	# For example:
	#   S3Object.store('/folder/to/greeting.txt', 'hello world!', 'ron', :use_virtual_directories => true)
	#
	# This will create an object in S3 that mimics a folder, as far as the S3 GUI browsers like
	# the S3 Firefox Extension or Bucket Explorer are concerned.
	#
	# Taken from http://deadprogrammersociety.blogspot.com/2008/01/making-s3-folders-in-ruby.html
    class Blog < S3Object
		set_current_bucket_to domain

		alias :original_store :store
		def store(key, data, bucket = nil, options = {})
			store_folders(key, bucket, options) if options[:use_virtual_directories]
			original_store(key, data, bucket, options)
		end

		def store_folders(key, bucket = nil, options = {})
			folders = key.split("/")
			folders.slice!(0)
			folders.pop
			current_folder = "/"
			folders.each {|folder|
				current_folder += folder
				store_folder(current_folder, bucket, options)
				current_folder += "/"
			}
		end

		def store_folder(key, bucket = nil, options = {})
			original_store(key + "_$folder$", "", bucket, options) # store the magic entry that emulates a folder
		end

		def self.store_if_changed(key, data, bucket = nil, options = {})
			changed = if exists?(key, bucket) then
				Blog.find(key, bucket).etag != MD5.hexdigest(data)
			else
				true
			end

			if changed then
				puts "Uploading #{key}" 
				store key, data, bucket, options
			else
				puts "Skipping #{key}" 
			end

		end
	end

	Base.establish_connection!(
    	:access_key_id     => ENV["AMAZON_ACCESS_KEY_ID"],
    	:secret_access_key => ENV["AMAZON_SECRET_ACCESS_KEY"]
	)

	cd "build" do
		Dir.glob("**/*").reject {|filename| File.directory? filename}.each do |filename|
			contents = File.open(filename).read
		  	Blog.store_if_changed filename, contents, domain, :use_virtual_directories => true, :access => :public_read
		end
	end

end
