require 'rake/common'

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
