.PHONY: help server build clean new draft deploy test

# Default target
help:
	@echo "Hugo Blog Makefile"
	@echo ""
	@echo "Available commands:"
	@echo "  make server       - Start Hugo development server with drafts"
	@echo "  make build        - Build the site for production"
	@echo "  make build-draft  - Build the site including drafts"
	@echo "  make clean        - Remove generated files (public/, resources/)"
	@echo "  make new POST=name - Create a new blog post"
	@echo "  make draft POST=name - Create a new draft post"
	@echo "  make deploy       - Build and prepare for deployment"
	@echo "  make test         - Test the build without publishing"
	@echo ""

# Start development server with drafts and live reload
server:
	@echo "Starting Hugo development server..."
	# hugo server -D --bind 0.0.0.0
	hugo server -D

# Build the site for production
build:
	@echo "Building site for production..."
	hugo --minify

# Build the site including drafts
build-draft:
	@echo "Building site with drafts..."
	hugo --minify -D

# Remove generated files
clean:
	@echo "Cleaning generated files..."
	rm -rf public/ resources/

# Create a new post (usage: make new POST=my-post-name)
new:
	@if [ -z "$(POST)" ]; then \
		echo "Error: POST variable is required. Usage: make new POST=my-post-name"; \
		exit 1; \
	fi
	@echo "Creating new post: $(POST)"
	hugo new posts/$(POST).md

# Create a new draft post (usage: make draft POST=my-draft-post)
draft:
	@if [ -z "$(POST)" ]; then \
		echo "Error: POST variable is required. Usage: make draft POST=my-draft-post"; \
		exit 1; \
	fi
	@echo "Creating new draft post: $(POST)"
	hugo new posts/$(POST).md
	@echo "Note: Set 'draft: true' in the front matter if not already set"

# Build and prepare for deployment
deploy: clean build
	@echo "Site built and ready for deployment in ./public"

# Test the build
test: clean build
	@echo "Build test completed successfully"
