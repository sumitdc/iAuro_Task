upstream iauro {
        
        server 127.0.0.1:8000 fail_timeout=0;
}

server {
        server_name test.iauro.com;
        listen 80;
        listen 443 ssl;
        ssl_session_timeout 5m;
        client_max_body_size 20M;
        gzip on;
        gzip_vary on;
        gzip_proxied any;
        gzip_comp_level 6;
        gzip_buffers 16 8k;
        gzip_http_version 1.1;
        gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ssl_certificate /etc/letsencrypt/live/test.iauro.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/test.iauro.com/privkey.pem;

        if ($scheme = http) {
        return 301 https://$server_name$request_uri;
        }
        
        location / {
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_set_header X-Forwarded-Proto https;
                #proxy_redirect off;
                proxy_redirect http:// $scheme://;
                proxy_connect_timeout      240;
                proxy_send_timeout         240;
                proxy_read_timeout         240;
                proxy_pass http://iauro;
        }
 }
