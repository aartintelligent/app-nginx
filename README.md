# App Nginx

### Usage

```shell
docker build . \
--tag aartintelligent/app-nginx:latest \
--build-arg "UID=$(id -u)" \
--build-arg "GID=$(id -g)" \
--build-arg "GIT_COMMIT=$(git rev-parse HEAD)"
```

```shell
docker run -it --rm \
--net host \
--name app-nginx \
aartintelligent/app-nginx:latest \
nginx -v
```

```shell
docker run -d \
--net host \
--name app-nginx \
aartintelligent/app-nginx:latest
```

```shell
docker container logs app-nginx
```

```shell
docker exec -it app-nginx supervisorctl status
```

```shell
docker exec -it app-nginx supervisorctl stop server-nginx:server-nginx
```

```shell
until docker exec -it app-nginx /docker/d-health.sh >/dev/null 2>&1; do \
  (echo >&2 "Waiting..."); \
  sleep 2; \
done
```

```shell
docker exec -it app-nginx supervisorctl start server-nginx:server-nginx
```

```shell
docker exec -it app-nginx bash
```

```shell
docker stop app-nginx
```

```shell
docker rm app-nginx
```
