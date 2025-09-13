# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal blog built with [Zola](https://www.getzola.org/), a fast static site generator written in Rust. The site uses the [archie-zola](https://github.com/XXXMrG/archie-zola) theme and is deployed to GitHub Pages.

## Architecture

- **Static Site Generator**: Zola (Rust-based)
- **Theme**: archie-zola (fork of athul/archie)
- **Content**: Markdown files in `content/` directory
- **Templates**: Tera templating engine in `templates/`
- **Static Assets**: Files in `static/` directory
- **Configuration**: `config.toml` for site settings

## Key Directories

- `content/` - Markdown content (posts, pages, about)
- `content/posts/` - Blog posts
- `content/protpets/` - Pet rescue content
- `static/` - Static assets (images, CSS, JS)
- `templates/` - HTML templates (Tera syntax)
- `themes/archie-zola/` - Theme files (submodule)

## Development Commands

### Build and Serve
```bash
# Build the site to public/ directory
zola build

# Serve locally with live reload (default: http://127.0.0.1:1111)
zola serve

# Serve with specific port and open browser
zola serve --port 3000 --open

# Build with drafts included
zola build --drafts
```

### Validation and Testing
```bash
# Check for build errors without rendering
zola check

# Validate internal links
zola check --check-links
```

### Deployment
```bash
# Build for production (public/ directory)
zola build

# The public/ directory is deployed to GitHub Pages
```

## Content Structure

- Posts: `content/posts/*.md`
- Pages: `content/*.md` (about.md, _index.md)
- Front matter in Markdown files includes metadata like title, date, tags

## Configuration

- Main config: `config.toml`
- Theme config: `themes/archie-zola/theme.toml`
- Base URL: `https://horaoen.github.io`
- Features: Syntax highlighting, search index, Sass compilation

## Theme Customization

The site uses the archie-zola theme as a git submodule. Customizations should be made carefully to avoid conflicts with theme updates.

## Common Tasks

- Add new blog post: Create `.md` file in `content/posts/`
- Update about page: Edit `content/about.md`
- Modify templates: Edit files in `templates/` (extends theme templates)
- Add static assets: Place in `static/` directory

## Dependencies

- **Zola**: Required for development (install via Homebrew: `brew install zola`)
- **Current version**: zola 0.21.0

## Deployment Workflow

1. Make content/template changes
2. Test locally with `zola serve`
3. Build with `zola build`
4. Commit and push to GitHub
5. GitHub Pages automatically deploys from public/ directory