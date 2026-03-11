# Stage 1: Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Fetch dependencies and build for web
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve using Nginx
FROM nginx:alpine

# Copy the build output to Nginx's default directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy the Nginx configuration
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
