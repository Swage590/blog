---
title: Building a Blog
published: 2025-09-28
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
- **GitHub Actions** – to automate tagging, building and publishing Docker images.
- **GitHub Container Registry (GHCR)** – to host the Docker images.
- **Kubernetes** - to deploy this blog's docker containers and load balance them across my hosts
- **Traefik** - The reverse proxy that serves the website and gives it that trusted certificate
- **Flux-CD** – to automatically update the running site when a new image is pushed.

---

## 2. Development Workflow

1. **Local development** –  
   It's simple for me to jump into the dev work, all I have to do is clone the site and start making posts, and once I push a commit the tech stack handles the rest.

   ```bash
   git clone https://github.com/Swage590/blog
   cd blog
   pnpm install
   npm run dev
   ```

This starts the Astro development server with hot reload, so I can see changes appear on the locally hosted dev site as I make them.

---

## 3. Dockerization

**GitHub Actions** is used to automate building the container and pushing it out to **GitHub Container Registry (GHCR)**:

1. Every push to the `master` branch triggers a workflow.
1. **Build stage** – installs dependencies and generates the static site.
2. **Runtime stage** – only includes the built `dist` folder and a lightweight server (`serve`), resulting in a small, production-ready image.
3. The image is then tagged with the date and pushed to **GitHub Container Registry (GHCR)**.

This ensures the runtime container contains **only what’s necessary** to serve the site, improving security and efficiency.

---

## 4. Continuous Deployment

On the production server, I run:

* **Kubernetes** – to deploy the containers across my hosts.
* **Flux-CD** – to automatically check for new images on GHCR every few minutes, once one is available it will checkout the main branch of my [Kubernetes config](https://github.com/Swage590/Kubernetes-Flux) and change the version, triggering a rolling update of my blog with 0 downtime.

This setup ensures the site is always up-to-date with the latest code without any manual intervention, nor any downtime.

::github{repo="swage590/Kubernetes-Flux"}

---

## 5. Benefits of This Approach

* **Consistency** – the same Docker image is used across all environments.
* **Immutability** – the running container is never modified directly; all changes go through the CI/CD pipeline.
* **Security** – the runtime container contains only the static site and server, no build tools or secrets.
* **Scalability** – Deploying to more hosts is as trivial as changing a number on config, and scaling to demand with kubernetes can also be automatic.

---

This workflow allows me to not have a million things to do after I write a new post, and it will send me a discord notification once it's done updating on prod.
