export BLOG_ID=00000001
export BLOG_TITLE="Hello world 3"
export BLOG_BODY=$(cat <<TEXT
<p>Well here we are again, with me trying another blogging engine. This time,
I'm moving away from a database-backed blog to a more simple static site. Gotta
figure how how to make it easy to post to. Maybe this will encourage me to write
longer form posts, instead of knee-jerk links.</p>
TEXT
)
export BLOG_DATE="2012-02-19T00:00 EST"
