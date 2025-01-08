+++
title = "nginx摘要"
date = "2024-10-12"
+++

[nginx doc](https://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size)
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

### 响应超时
```conf
Syntax:	proxy_read_timeout time;
Default:	
proxy_read_timeout 60s;
Context:	http, server, location
```

### 413 文件大小限制
```conf
Syntax:	client_max_body_size size;
Default:	
client_max_body_size 1m;
Context:	http, server, locations
```

### CSP
- [csp mdn doc](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CSP)

- nginx `add_header Content-Security-Policy img-src * 'self' data: blob: https: http:`