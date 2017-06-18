export BLOG_ID=00000009
export BLOG_TITLE="Encrypt your local AWS credentials with aws-vault"
export BLOG_BODY=$(cat <<TEXT
<p>I want to start blogging again, so that means figuring out how my static site generator works again. Turns out its ruby dependencies have rotted, so I'm just gonna copy-paste the html to publish stuff.</p>
<p>Next step: redownload the content from s3. Since I wiped my laptop since I last published, I don't have the original AWS keys I used to post, so I took the opportunity to Do The Right Thing and immediately put my new AWS keys in aws-vault encrypted files.</p>
<p>Normally to use AWS APIs from a workstation command line, you need to pass AWS credentials either via a plaintext config file, or in environment variables, presumably from sourced from a plaintext bashrc file or similar. This leaves your credentials vulnerable if some malware manages to get on your machine and looks for AWS credentials, or if you laptop gets stolen and your hard drive isn't encrypted, or is encrypted but you've already logged in before its been stolen.</p>
<p>You could probably encrypt your AWS credentials file with GPG and have some wrapper script to decrypt it when you're trying to use the AWS command line tools, but aws-vault makes this much more conventient for you. How it works:</p>
<ol>
  <li><p>Download <a href="https://github.com/99designs/aws-vault/releases">aws-vault</a> and put it in your PATH. Since it's a Go app, it's a single self-contained binary which is convenient. If you're running Arch Linux, it's also in the <a href="https://aur.archlinux.org/packages/aws-vault">AUR</a></p></li>
  <li><p>To add your credentials:</p>
<pre><code class="language-bash">$ aws-vault add my-profile<br />
Enter Access Key ID:<br />
Enter Secret Access Key:<br />
Enter passphrase to unlock /home/carlo/.awsvault/keys:
</code></pre>
  <p>The passphrase is the encryption key to encrypt and decrypt those credentials, so don't leave it blank.
  </p></li>
  <li><p>To use the credentials: <br />
<pre><code class="language-bash">$ aws-vault exec personal ./my-script-that-needs-aws-creds<br />
Enter passphrase to unlock /home/carlo/.awsvault/keys:
</code></pre>
  </p></li>
</ol>
<p>Now, your credentials aren't in plaintext at rest. For some extra protection, you can add these parameters:</p>
<ul>
  <li><p><strong>--session-ttl</strong> - Defaults to 4h but for increased security, you can reduce that time. Conversely, if you get tired of recreating your <code>aws-vault</code> session, you can increase the time, though it increases the amount of time a bad guy has to use your creds if your machine gets stolen.</p></li>
  <li><p><strong>--mfa-token</strong> - If you have <a href="http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html">multi-factor auth</a> enabled on your IAM account, you can pass those tokens into <code>aws-vault</code></p></li>
</ul>
TEXT
)
export BLOG_DATE="2017-06-04T00:00 PDT"
