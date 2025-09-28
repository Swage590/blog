---
title: How it's made - This site!
published: 2025-09-27
description: This is my first post detailing how I've built this blog site and details the development workflow.
tags: [Docker, Github, Automation, IaC]
category: Infrastructure
draft: false
---

# How This Website is Built and Deployed

This website is a modern, static site built with [**Astro**](https://astro.build/), and using the static blog template [**Fuwari**](https://github.com/saicaca/fuwari) template. Here’s a behind-the-scenes look at how it’s built and deployed.

::github{repo="swage590/blog"}

---

## 1. The Tech Stack

- **Astro** – the core framework, chosen for its speed, component-based architecture, and ability to generate static HTML.
- **Node.js** – for building and managing the site.
- **pnpm** – a fast, disk-efficient package manager used for dependency management.
- **Docker** – to containerize the application and ensure consistent builds across environments.
- **GitHub Actions** – to automate building and publishing Docker images.
- **GitHub Container Registry (GHCR)** – to host the Docker images.
- **Watchtower** – to automatically update the running site when a new image is pushed.

---

## 2. Development Workflow

1. **Local development** –  
   Developers clone the repository and run:

   ```bash
   git clone https://github.com/Swage590/blog
   cd blog
   pnpm install
   pnpm dev
   ```

This starts the Astro development server with hot reload.

2. **Building the site** –
   When ready to deploy, the site is built with:

   ```bash
   pnpm run build
   ```

   This generates a static `dist` folder containing optimized HTML, CSS, and JavaScript.

---

## 3. Dockerization

The site is packaged into a Docker image using a **multi-stage Docker build**:

1. **Build stage** – installs dependencies and generates the static site.
2. **Runtime stage** – only includes the built `dist` folder and a lightweight server (`serve`), resulting in a small, production-ready image.

This ensures the runtime container contains **only what’s necessary** to serve the site, improving security and efficiency.

---

## 4. Continuous Deployment

**GitHub Actions** is used to automate deployment:

1. Every push to the `master` branch triggers a workflow.
2. The workflow builds a new Docker image of the site.
3. The image is pushed to **GitHub Container Registry (GHCR)**.

---

## 5. Auto-Updating Production Site

On the production server, I run:

* **Docker Compose** – to manage the containerized site.
* **Watchtower** – to automatically check for new images on GHCR every few minutes and restart the container when a new version is available.

This setup ensures the site is always up-to-date with the latest code without any manual intervention.

---

## 6. Benefits of This Approach

* **Consistency** – the same Docker image is used across all environments.
* **Immutability** – the running container is never modified directly; all changes go through the CI/CD pipeline.
* **Security** – the runtime container contains only the static site and server, no build tools or secrets.
* **Scalability** – deploying to additional servers or cloud providers is as simple as running the Docker image.

---

This workflow allows us to focus on writing content and improving the site, while the automation ensures it is built and deployed reliably every time.
