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
			generated_file = "build/posts/" + File.basename(post)
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
	post_path = "/posts/#{post_id}.html"

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


