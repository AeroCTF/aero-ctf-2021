###Build task
```sh
docker-compose -f docker/docker-compose.yml --project-name XSSproxy "$@" build
```
or
```sh
./control.sh build
```

###Run task
```sh
docker-compose -f docker/docker-compose.yml --project-name XSSproxy "$@" up
```
or
```sh
./control.sh up
```

###Scale Celery worker and Selenium
```sh
docker-compose -f docker/docker-compose.yml --project-name XSSproxy "$@" scale check=16
```
or
```sh
./control.sh scale check=16
```

###Stop task
```sh
docker-compose -f docker/docker-compose.yml --project-name XSSproxy "$@" down
```
or
```sh
./control.sh down
```