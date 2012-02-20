require 'erb'
require 'date'
require 'fileutils'


task :default => [:clean, :generate]

directory "build"
directory "build/posts"
directory "build/img"
directory "build/css"
directory "build/js"

task :generate => ["generate:assets", "generate:content"]

namespace :generate do
	task :assets => [:img, :css, :js]
	task :content => [:posts, :index]

	task :img => ["build/img"] do 
		sh "cp assets/img/* build/img/" 
	end	

	task :css => ["build/css"] do 
		sh "cp assets/css/*.min.css build/css/" 
	end	

	task :js => ["build/js"] do 
		sh "cp assets/js/*.min.js build/js/" 
	end	

	desc "Generates the individual post files"
	task :posts => ["build", "build/posts"] do
		top = File.open("content/layout/top.html").read
		bottom = File.open("content/layout/bottom.html").read
		Dir.glob("content/posts/*.html").each do |post_file|
			post = File.open(post_file).read
			generated_file = "build/" + File.basename(post_file)
			File.open(generated_file, "w") do |f|
				f.write top + post + bottom
			end
		end
	end


	task :index => ["build"]  do
		top = File.open("content/layout/top.html").read
		bottom = File.open("content/layout/bottom.html").read

		posts = Dir.glob("content/posts/*.html").sort.reverse.map do |post_file|
			File.open(post_file).read
		end.join("\n")

		File.open("build/index.html", "w").write(top + posts + bottom)
	end
end

task :new_post do
	post_id = "%08d" % (Dir.glob('content/posts/*.html').inject(0) do |max, file| 
		[max, File.basename(file, ".html").to_i].max
	end + 1) 
	date = Date.today.strftime "%a, %b %-d, %Y"
	post_path = "#{post_id}.html"

	template = ERB.new <<-EOF
	<article id="post-<%= post_id %>">
	  <h2><a name="post-<%= post_id %>" class="permalink icon-bookmark" href="<%= post_path %>">&nbsp;</a> TITLE <small><%= date %></h2>
	  BODY
	</article>
	EOF
	new_post = template.result(binding)

	file_path = "content" + post_path
	puts file_path
	File.open(file_path, "w") { |io| io.write(new_post) }
end

task :clean do
	rm_rf "build"
end


namespace :server do
	http_server = "python -m SimpleHTTPServer"
	task :start => [:stop] do |t|
		cd "build" do 
			sh "#{http_server} >> ../http.log 2>&1 &"
		end
	end

	task :stop do |t|
		begin
			sh "pkill -f '#{http_server}'"
		rescue Exception => e
			
		end
	end
end

task :publish do
	require 'rubygems'
	require 'aws/s3'
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
		set_current_bucket_to "www.syntacticbayleaves.com"

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
	end

	Base.establish_connection!(
    	:access_key_id     => ENV["AMAZON_ACCESS_KEY_ID"],
    	:secret_access_key => ENV["AMAZON_SECRET_ACCESS_KEY"]
	)

	cd "build" do
		Dir.glob("**/*").reject {|filename| File.directory? filename}.each do |filename|
			contents = File.open(filename).read
			puts filename
		  	Blog.store filename, contents, :use_virtual_directories => true, :access => :public_read
		end
	end

end
