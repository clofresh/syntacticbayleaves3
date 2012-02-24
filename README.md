# Syntactic Bay Leaves 3

My blog as a collection of html snippets and some extremely simple rake and erb scripts to mash them all together and sprinkle them into Amazon's fluffy cloud, S3.

The content is licensed under the [Creative Commons Attribution-ShareAlike 3.0 license](http://creativecommons.org/licenses/by-sa/3.0/), while the site generation scripts are licensed under the BSD license. 

To generate the site:

	rake generate

To view the site locally:

	rake server:start

And open a browser to localhost:8000 (Requires `python` to be in your path)

To publish the site, you'll need the AWS::S3 library:

	sudo gem install aws-s3

And you must have your AWS keys and S3 bucket set as environment variables:

	export AMAZON_ACCESS_KEY_ID=my_access_key_id
	export AMAZON_SECRET_ACCESS_KEY=my_secret_access_key
	export BLOG_S3_BUCKET=www.myawesomeblog.com

Then run:

	rake publish

Which will upload everything in the `build` directory to your S3 bucket, preserving the directory structure and skipping files that haven't changed. Note: AWS requires you to name your S3 bucket after the domain of your blog or else you won't be able to refer to the S3 bucket with your own CNAME.

There's still a bunch of stuff that's specific to my blog, so if you wanna use the site generator, then you'll have to rejigger the code a bit. Eventually I'll generalize it into a library.
