# 📖 Flutter Web to AWS EC2: Complete CI/CD Tutorial

This tutorial provides a comprehensive, step-by-step guide to dockerizing your Flutter Web application and deploying it via a GitHub Actions pipeline to an AWS EC2 instance.

---

## 🏗️ Phase 1 — Local Project Files

We need to add 5 files to your Flutter project to make it "Docker-ready."

### 1. `Dockerfile`
A multi-stage build that:
1.  Uses a Flutter image to build the web output
2.  Uses an Nginx image to serve the resulting static files

```dockerfile
# Stage 1: Build Stage
FROM instruments/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve Stage
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 2. `nginx/nginx.conf`
Ensures that all client-side routes (e.g., `/home`, `/details`) correctly serve the `index.html` file, which is crucial for Single Page Applications (SPAs) like Flutter Web.

```nginx
server {
    listen 80;
    location / {
        root /usr/share/nginx/html;
        try_files $uri $uri/ /index.html;
    }
}
```

### 3. `.dockerignore`
Keeps the build context small by excluding local directories like `build/`, `.dart_tool/`, and platform-specific code (`ios/`, `android/`).

### 4. `.github/workflows/deploy.yml`
The core of your pipeline. It triggers on every push to the `main` branch.

**Key Steps:**
- **Checkout:** Downloads code to the runner.
- **Login:** Authenticates with Docker Hub.
- **Build & Push:** Creates the Docker image and uploads it to Docker Hub.
- **Deploy:** SSHes into EC2 and runs `docker compose`.

---

## ☁️ Phase 2 — AWS EC2 Configuration

Follow these steps to prepare your server:

### 1. Launch Your Instance
- **OS:** Ubuntu 22.04 LTS
- **Security Group:** Add an Inbound Rule for **HTTP (Port 80)** with source `0.0.0.0/0`.
- **Key Pair:** Save your `.pem` file; we'll use it to connect.

### 2. Install Docker on EC2
Run these commands in your EC2 terminal:
```bash
sudo apt update
sudo apt install -y docker.io docker-compose-plugin
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
# IMPORTANT: Log out and log back in for permissions to take effect
exit
```

---

## 🔐 Phase 3 — GitHub Secrets

Go to: **GitHub → Repo Settings → Secrets and variables → Actions**

Add these 6 Secrets:

| Secret Name | Description | Example / How to get |
|---|---|---|
| `HOST` | The Public IPv4 of your EC2 | `13.127.x.x` |
| `USERNAME` | Your EC2 User | `ubuntu` |
| `SSH_KEY` | Contents of your `.pem` file | `Get-Content "key.pem" -Raw` |
| `DOCKER_USERNAME` | Your Docker Hub Username | `akhi1babu` |
| `DOCKER_PASSWORD` | Docker Hub Access Token | *Settings → Security → New Access Token* |
| `GEMINI_API_KEY` | Your AI Key | *From Google AI Studio* |

---

## 🚀 Phase 4 — Triggering the Pipeline

1. **Commit and Push:**
   ```bash
   git add .
   git commit -m "🚀 Initial CI/CD deployment"
   git push origin main
   ```
2. **Watch the Magic:** Go to the **Actions** tab on GitHub to watch the build and deployment progress.
3. **Verify:** Once the pipeline is green, visit `http://YOUR_EC2_IP` in your browser.

---

## 🛠️ Key Troubleshooting Tips
1. **Trailing Newlines:** Ensure secrets (especially `SSH_KEY`) don't have extra spaces or blank lines.
2. **CORS:** Flutter Web images may fail if served directly. Use the Weserv proxy included in `GeminiService`.
3. **API Key:** Ensure `GEMINI_API_KEY` is added to GitHub Secrets, as the runner will use it during build.

---
