user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    proxy_send_timeout 120;
    proxy_read_timeout 300;
    proxy_buffering    off;
    keepalive_timeout  5 5;
    tcp_nodelay        on;

    server_names_hash_bucket_size  64;
    
    server {
        listen         80;
        server_name    {{SERVER_NAME}};

        return         301 https://$server_name$request_uri;
    }

    server {
      listen              1433  http2;
      server_name         {{SERVER_NAME}}; 
      
      #ssl on;

      #ssl_certificate           /etc/nginx/ssl/ssl.crt;
      #ssl_certificate_key       /etc/nginx/ssl/ssl.key;

      #ssl_verify_client         off;

      #ssl_session_cache         shared:SSL:10m;
      #ssl_session_timeout       10m;
      #ssl_protocols             TLSv1 TLSv1.1 TLSv1.2;
      #ssl_ciphers               ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA;
      #ssl_prefer_server_ciphers on;
      #ssl_stapling              on;
      #ssl_stapling_verify       on;
      
      #access_log /tmp/access.log main;
      #error_log /tmp/error.log error;
      
      location / {    
          grpc_pass grpc://icb-network:5031;
          #health_check type=grpc grpc_status=12; # 12=unimplemented
      }

      # Error responses
      #include conf.d/errorsgrpc.conf; # gRPC-compliant error responses
      #default_type application/grpc;   # Ensure gRPC for all error responses
    }

    server {
      listen       443 ssl;
      server_name {{SERVER_NAME}};

      ssl on;

      ssl_certificate           /etc/nginx/ssl/ssl.crt;
      ssl_certificate_key       /etc/nginx/ssl/ssl.key;

      ssl_verify_client         off;

      ssl_session_cache         shared:SSL:10m;
      ssl_session_timeout       10m;
      ssl_protocols             TLSv1 TLSv1.1 TLSv1.2;
      ssl_ciphers               ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA;
      ssl_prefer_server_ciphers on;
      ssl_stapling              on;
      ssl_stapling_verify       on;

      location / {
        proxy_pass http://icb-network:5030;
        proxy_read_timeout    120;
        proxy_connect_timeout 90;
        proxy_redirect        off;
        client_max_body_size 8G;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
      }

      location /db {
        proxy_pass http://mongo-express:8081;
        proxy_read_timeout    120;
        proxy_connect_timeout 90;
        proxy_redirect        off;
        client_max_body_size 8G;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
      }
    }

    map $http_upgrade $connection_upgrade {
      default upgrade;
      '' close;
    }

    #map $upstream_trailer_grpc_status $grpc_status {
    #  default $upstream_trailer_grpc_status; # grpc-status is usually a trailer
    #  ''      $sent_http_grpc_status; # Else use the header, whatever its source
    #}
}
