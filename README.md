# Syntactic Bay Leaves 3

A make-based static blog.

The content is licensed under the [Creative Commons Attribution-ShareAlike 3.0 license](http://creativecommons.org/licenses/by-sa/3.0/),
while the site generation scripts are licensed under the BSD license.

To generate the site locally:

```
make build DOMAIN=www.syntacticbayleaves.com
```

I've only tested this on Arch Linux, so other *nix's with older bash or without
`envsubst` might fail.


To publish the site to S3:

```
make publish DOMAIN=www.syntacticbayleaves.com AWS_PROFILE=myprofile
```

Publishing depends on [aws-vault](https://github.com/99designs/aws-vault) and the
[aws cli tool](https://aws.amazon.com/cli/). AWS_PROFILE should be an aws-vault
profile you've already configured to be able to write to your $DOMAIN's s3 bucket.
See my post on [setting up aws-vault](https://www.syntacticbayleaves.com/00000009.html)
to see how to do that.
