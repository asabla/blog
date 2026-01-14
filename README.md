# blog

Simple things and stuff

## Prerequisites

- [Hugo](https://gohugo.io/) (v0.154.5 or later)
- Make (optional, but recommended for easier workflow)

## Quick Start

### Using Make (Recommended)

The repository includes a Makefile with common Hugo commands. Run `make help` to see all available commands:

```bash
make help
```

### Common Commands

#### Development

Start the development server with live reload and draft posts enabled:

```bash
make server
```

The site will be available at `http://localhost:1313`

#### Creating Content

Create a new blog post:

```bash
make new POST=my-post-name
```

This creates a new post at `content/posts/my-post-name.md`

#### Building

Build the site for production:

```bash
make build
```

Build including draft posts (for testing):

```bash
make build-draft
```

Build and prepare for deployment (cleans first):

```bash
make deploy
```

#### Maintenance

Clean generated files:

```bash
make clean
```

Test the build:

```bash
make test
```

## Manual Commands (Without Make)

If you prefer not to use Make, you can run Hugo commands directly:

* Create a new post
  * `hugo new posts/post-name.md`
* Start development server
  * `hugo server -D`
* Build for production
  * `hugo --minify`
* Build with drafts
  * `hugo --minify -D`

## CI/CD

The repository uses GitHub Actions for automated deployment:

- Pushes to `main` branch trigger automatic builds
- Site is deployed to GitHub Pages
- Hugo version: 0.154.5 (extended)

## Project Structure

```
.
├── archetypes/       # Content templates
├── content/          # Site content (posts, pages)
├── layouts/          # Custom HTML templates
├── static/           # Static assets (images, css, js)
├── themes/           # Hugo themes (git submodules)
├── config.toml       # Hugo configuration
└── Makefile          # Build automation
```
