FROM nginx:1.26-alpine
COPY . /usr/share/nginx/html
EXPOSE 7070
CMD ["nginx", "-g", "daemon off;"]

#This is to verify if Git work correctly
