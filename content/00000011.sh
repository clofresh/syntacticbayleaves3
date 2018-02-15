export BLOG_ID=00000011
export BLOG_TITLE="Syntactic Bay Leaves is now HTTPS-secured"
export BLOG_BODY=$(cat <<TEXT
<p>Now that Chrome is shaming everyone into using HTTPS and crypto kiddies are <a href="https://arnaucode.com/blog/coffeeminer-hacking-wifi-cryptocurrency-miner.html">man-in-the-middleing you with javascript miners</a>, I decided it's time to convert the ol' blog to HTTPS.</p>

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">A secure web is here to stay! Chrome will mark all HTTP sites as &quot;Not secure&quot; in July 2018. 🔐⚠️ <a href="https://t.co/hcIqQvYHUM">https://t.co/hcIqQvYHUM</a></p>&mdash; Google Chrome (@googlechrome) <a href="https://twitter.com/googlechrome/status/961732373451653120?ref_src=twsrc%5Etfw">February 8, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<p>I host this blog as an S3 <a href="https://github.com/clofresh/syntacticbayleaves3">static site</a>, but S3 doesn't offer HTTPS for their buckets. I could use Cloudfront, but it always felt a little clunky when I worked with it in the past. That said, after doing some after-the-fact research, I found that someone has create <a href="https://github.com/ringods/terraform-website-s3-cloudfront-route53">some Terraform modules</a> to automate this very thing.</p>

<p>Anyways, I went with <a href="https://www.cloudflare.com/plans/">Cloudflare</a> since they have a free plan the lets me use their shared TLS certificate, with the added bonus of caching the contents to shave millipennies off of the pennies I pay for S3 hosting.</p>

<p>And now you can peruse this blog without fear. Enjoy.</p>
TEXT
)
export BLOG_DATE="2018-02-14T15:08 PST"
