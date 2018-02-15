# Configuration
BROWSER ?= /usr/bin/google-chrome-stable
DOMAIN ?= www.syntacticbayleaves.com
AWS_PROFILE ?= personal

SHELL=/bin/bash -eo pipefail

# Templates
TMP_DIR=tmp
TMPL_DIR=templates
HTML_TMPL_DIR=$(TMPL_DIR)/html
RSS_TMPL_DIR=$(TMPL_DIR)/rss
SITEMAP_TMPL_DIR=$(TMPL_DIR)/sitemap
CONTENT_DIR=content

# Date formats
HTML_DATE_FORMAT=%a, %b %d, %Y
RSS_DATE_FORMAT=%a, %d %b %Y %T GMT
SITEMAP_DATE_FORMAT=%F

# File lists
HTML_TMPL_FILES=$(shell find $(HTML_TMPL_DIR) -type f)
RSS_TMPL_FILES=$(shell find $(RSS_TMPL_DIR) -type f)
SITEMAP_TMPL_FILES=$(shell find $(SITEMAP_TMPL_DIR) -type f)

CONTENT_FILES=$(shell find $(CONTENT_DIR) -maxdepth 1 -name '[0-9]*.sh' | sort -nr)
HTML_FRAGS=$(shell echo $(CONTENT_FILES) | sed -e 's@$(CONTENT_DIR)@$(TMP_DIR)@g' -e 's/.sh/.frag.html/g' | sort -nr)
RSS_FRAGS=$(shell echo $(CONTENT_FILES) | sed -e 's@$(CONTENT_DIR)@$(TMP_DIR)@g' -e 's/.sh/.frag.rss.xml/g' | sort -nr)
SITEMAP_FRAGS=$(shell echo $(CONTENT_FILES) | sed -e 's@$(CONTENT_DIR)@$(TMP_DIR)@g' -e 's/.sh/.frag.sitemap.xml/g' | sort -nr)
ARTICLE_FILES=$(shell echo $(CONTENT_FILES) | sed -e 's@$(CONTENT_DIR)@$(DOMAIN)@g' -e 's/.sh/.html/g')
INDEX_FILE=$(DOMAIN)/index.html
ALL_FILES=$(DOMAIN) $(INDEX_FILE) $(DOMAIN)/index.rss.xml $(DOMAIN)/sitemap.xml $(ARTICLE_FILES)

# ------------------------------------------------------------------------------
# Default Rule
# ------------------------------------------------------------------------------

# Build everything
build: $(ALL_FILES)
	@echo "Opening $(INDEX_FILE) in a browser"
	@$(BROWSER) $(INDEX_FILE) > /dev/null

# Sync changed files to s3. aws-vault will prompt for the aws credentials's passphrase
publish: $(ALL_FILES)
	@aws-vault exec $(AWS_PROFILE) -- aws s3 sync --acl public-read $(DOMAIN)/ s3://$(DOMAIN)/
	@$(BROWSER) http://$(DOMAIN)/ > /dev/null

# ------------------------------------------------------------------------------
# Html Rules
# ------------------------------------------------------------------------------

# Create the directory
$(DOMAIN):
	@mkdir -p $@

# Build the html index
$(DOMAIN)/index.html: $(HTML_FRAGS) $(HTML_TMPL_FILES)
	@echo "Generating home page: $@"
	@cat $(HTML_TMPL_DIR)/header.html $(HTML_FRAGS) $(HTML_TMPL_DIR)/footer.html > $@

# Rule for building individual article pages
$(DOMAIN)/%.html: $(TMP_DIR)/%.frag.html $(HTML_TMPL_FILES)
	@echo "Generating html article: $@"
	@cat $(HTML_TMPL_DIR)/header.html $< $(HTML_TMPL_DIR)/footer.html > $@

# Rule for building the html fragments
$(TMP_DIR)/%.frag.html: $(CONTENT_DIR)/%.sh $(HTML_TMPL_DIR)/article.html $(TMP_DIR)
	@echo "Generating html fragment: $@"
	@. $< && export BLOG_NICE_DATE="$$(date -d "$${BLOG_DATE}" +'${HTML_DATE_FORMAT}')" && \
	envsubst '$${BLOG_ID} $${BLOG_TITLE} $${BLOG_BODY} $${BLOG_NICE_DATE}' \
		< $(HTML_TMPL_DIR)/article.html > $@


# ------------------------------------------------------------------------------
# RSS Rules
# ------------------------------------------------------------------------------

# Build the rss feed
$(DOMAIN)/index.rss.xml: $(RSS_FRAGS) $(RSS_TMPL_FILES)
	@echo "Generating rss feed: $@"
	@export BLOG_BUILD_DATE="$$(date -u +'$(RSS_DATE_FORMAT)')" && \
	envsubst '$${BLOG_BUILD_DATE}' < $(RSS_TMPL_DIR)/header.rss.xml > $@
	@cat $(RSS_FRAGS) $(RSS_TMPL_DIR)/footer.rss.xml >> $@

# Rules for building the rss fragments
$(TMP_DIR)/%.frag.rss.xml: $(CONTENT_DIR)/%.sh $(RSS_TMPL_DIR)/article.rss.xml $(TMP_DIR)
	@echo "Generating rss fragment: $@"
	@. $< && export BLOG_GMT_DATE="$$(date -ud "$${BLOG_DATE}" +'${RSS_DATE_FORMAT}')" && \
	envsubst '$${BLOG_ID} $${BLOG_TITLE} $${BLOG_BODY} $${BLOG_GMT_DATE}' \
		< $(RSS_TMPL_DIR)/article.rss.xml > $@


# ------------------------------------------------------------------------------
# Sitemap Rules
# ------------------------------------------------------------------------------

# Build the sitemap
$(DOMAIN)/sitemap.xml: $(SITEMAP_FRAGS) $(SITEMAP_TMPL_FILES)
	@echo "Generating sitemap: $@"
	@cat $(SITEMAP_TMPL_DIR)/header.xml $(SITEMAP_FRAGS) > $@
	@export BLOG_INDEX_LAST_MOD="$$(date -u +'$(SITEMAP_DATE_FORMAT)')" && \
	envsubst '$${BLOG_INDEX_LAST_MOD}' < $(SITEMAP_TMPL_DIR)/footer.xml >> $@

# Rules for building the sitemap fragments
$(TMP_DIR)/%.frag.sitemap.xml: $(CONTENT_DIR)/%.sh $(SITEMAP_TMPL_DIR)/article.xml $(TMP_DIR)
	@echo "Generating sitemap fragment: $@"
	@. $< && export BLOG_ISO8601_DATE="$$(date -ud "$${BLOG_DATE}" +'$(SITEMAP_DATE_FORMAT)')" && \
	envsubst '$${BLOG_ID} $${BLOG_ISO8601_DATE}' \
		< $(SITEMAP_TMPL_DIR)/article.xml > $@


# ------------------------------------------------------------------------------
# Misc rules
# ------------------------------------------------------------------------------

$(TMP_DIR):
	@mkdir $@

# Dump the make variables
debug_info:
	@echo CONTENT_FILES=$(CONTENT_FILES)
	@echo HTML_TMPL_FILES=$(HTML_TMPL_FILES)
	@echo HTML_FRAGS=$(HTML_FRAGS)
	@echo RSS_TMPL_FILES=$(RSS_TMPL_FILES)
	@echo RSS_FRAGS=$(RSS_FRAGS)
	@echo SITEMAP_TMPL_FILES=$(SITEMAP_TMPL_FILES)
	@echo SITEMAP_FRAGS=$(SITEMAP_FRAGS)
	@echo ARTICLE_FILES=$(ARTICLE_FILES)

# Clean up temporary files
clean:
	@rm -f $(TMP_DIR)/*

# Rules that don't output files
.PHONY: build clean debug_info publish
