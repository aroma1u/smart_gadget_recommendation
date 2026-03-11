# Serve the pre-built Flutter Web output using Nginx
FROM nginx:alpine

# Copy the Flutter web build (created by the CI runner step before Docker build)
COPY build/web /usr/share/nginx/html

# Use custom Nginx config for SPA routing
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
