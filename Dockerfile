FROM nginx:1.25-alpine
RUN printf '%s\n' \
        '<!doctype html>' \
        '<html lang="fr">' \
        '<head><meta charset="utf-8"><title>Next-Gen DevSecOps</title></head>' \
        '<body style="font-family: Arial, sans-serif; margin: 40px;">' \
        '<h1>Next-Gen DevSecOps</h1>' \
        '<p>Application deployee automatiquement sur AWS EC2</p>' \
        '<p>Pipeline CI/CD, Docker, Terraform et securite DevSecOps valides</p>' \
        '</body></html>' \
        > /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]