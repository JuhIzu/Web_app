FROM nginx:alpine
COPY public-html/index.html /usr/share/nginx/html
COPY public-html/inventory.html /usr/share/nginx/html
COPY public-html/user.html /usr/share/nginx/html

EXPOSE 80
