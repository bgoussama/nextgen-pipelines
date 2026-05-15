
    FROM nginx:1.25-alpine
    RUN adduser -D -H appuser
    USER appuser
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]
  