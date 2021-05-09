FROM nginx:alpine
COPY index.html /usr/share/nginx/html
COPY inventory.html /usr/share/nginx/html
COPY user.html /usr/share/nginx/html

EXPOSE 80
