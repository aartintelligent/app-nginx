FROM aartintelligent/app-base:latest

USER root

ARG NGINX_WORKER_PROCESSES="5"
ARG NGINX_WORKER_CONNECTIONS="512"
ARG NGINX_CONFIGS="/etc/nginx/conf.d/*.conf"
ARG NGINX_SITE_ENABLED="/etc/nginx/sites-enabled/*.conf"
ARG NGINX_SERVER_NAME="_"

ENV \
APP_RUNTIME="supervisord" \
APP_RUNTIME_CLI="bash" \
NGINX_WORKER_PROCESSES="${NGINX_WORKER_PROCESSES}" \
NGINX_WORKER_CONNECTIONS="${NGINX_WORKER_CONNECTIONS}" \
NGINX_CONFIGS="${NGINX_CONFIGS}" \
NGINX_SITE_ENABLED="${NGINX_SITE_ENABLED}" \
NGINX_SERVER_NAME="${NGINX_SERVER_NAME}"

RUN set -eux; \
mkdir -p /usr/share/keyrings; \
curl -fsSL https://nginx.org/keys/nginx_signing.key \
| gpg --dearmor -o /usr/share/keyrings/nginx.gpg; \
echo \
"deb [arch=$(dpkg --print-architecture) \
signed-by=/usr/share/keyrings/nginx.gpg] \
http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" \
| tee /etc/apt/sources.list.d/nginx.list > /dev/null

RUN set -eux; \
apt-get update; \
apt-get install -y --no-install-recommends \
nginx

RUN set -eux; \
mkdir -p \
/etc/nginx \
/var/cache/nginx \
/var/log/nginx \
/var/lib/nginx; \
chmod 777 -R \
/etc/nginx \
/var/cache/nginx \
/var/log/nginx \
/var/lib/nginx; \
chown rootless:rootless \
/etc/nginx \
/var/cache/nginx \
/var/log/nginx \
/var/lib/nginx; \
rm -rf \
/var/www/* \
/etc/nginx/sites-available/* \
/etc/nginx/sites-enabled/*

COPY --chown=rootless:rootless system /

RUN set -eux; \
echo "/docker/d-bootstrap-nginx.sh" >> /docker/d-bootstrap.list; \
chmod +x /docker/d-*.sh

EXPOSE 8080

USER rootless
