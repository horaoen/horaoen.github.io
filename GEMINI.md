# Gemini Context - horaoen.github.io

This `GEMINI.md` file provides context and instructions for working with this Zola-based static site project.

## Project Overview

This project is a personal blog and website for **horaoen**, built using the **Zola** static site generator. It is hosted on GitHub Pages at `https://horaoen.github.io`.

*   **Framework**: [Zola](https://www.getzola.org/) (Rust-based SSG).
*   **Theme**: `archie-zola` (a fork of `athul/archie`).
*   **Language**: Markdown (content), TOML (config), HTML/Tera (templates), CSS/Sass.

## Key Directories & Files

*   `config.toml`: Main site configuration (URL, theme settings, navigation menus).
*   `content/`: Contains all site content in Markdown format.
    *   `posts/`: Blog posts.
    *   `protpets/`: Pet rescue records.
    *   `about.md`: About page.
*   `static/`: Static assets like images, CSS, and fonts.
    *   `static/posts/`: Images specific to blog posts.
*   `templates/`: Custom HTML templates using the Tera engine. Files here override theme templates.
*   `themes/archie-zola/`: The submodule for the base theme.
*   `.github/workflows/`: CI/CD configuration (likely for building and deploying the site).

## Building and Running

### Prerequisites
*   **Zola**: Must be installed (e.g., `brew install zola` on macOS).

### Commands

*   **Development Server**:
    ```bash
    zola serve
    ```
    Starts a local server (default: `http://127.0.0.1:1111`) with hot reloading.

*   **Build for Production**:
    ```bash
    zola build
    ```
    Generates the static site in the `public/` directory.

*   **Check Validity**:
    ```bash
    zola check
    ```
    Checks for errors without building the entire site.

## Development Conventions

### Content Creation
*   **Posts**: Create new Markdown files in `content/posts/`.
*   **Front Matter**: Files should use TOML front matter. Example:
    ```toml
    +++
    title = "My Post Title"
    date = 2025-12-07
    template = "page.html" # Optional, defaults usually suffice
    tags = ["tag1", "tag2"]
    +++
    ```

### Theme & Customization
*   **Overriding**: To customize the theme, copy the relevant file from `themes/archie-zola/templates/` to the project's root `templates/` directory and modify it there. Do not edit files inside `themes/` directly to ensure easier upgrades.
*   **CSS**: Custom CSS can be handled in `static/` or by modifying theme styles if configured.

### Deployment
*   The site is deployed via GitHub Actions (see `.github/workflows/main.yml`).
*   The build process typically runs `zola build` and publishes the `public/` directory.
