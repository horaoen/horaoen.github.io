+++
title = "nginx摘要"
date = "2024-10-12"
+++

```conf
server {

    location ~ /\.DS_Store {
        deny all;
        access_log off;
        log_not_found off;
    }

    add_header Content-Security-Policy
        "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self' *;";

    add_header X-Frame-Options DENY;

    listen 8020;
    server_name localhost;
    error_page 405 =200 $uri;

    location / {
        root /app/xzfw/car-moa-ui;
        index index.html index.htm;
        try_files $uri $uri/ /index.html;
    }

}
```

```conf
nginx -s reload
```

### history模式路由访问不到
```conf
location / {
    ...
    try_files $uri $uri/ /index.html;
    ...
}
```