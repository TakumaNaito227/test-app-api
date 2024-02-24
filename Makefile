up:
	docker-compose up api -d

down:
	docker-compose stop api db
	docker-compose rm -f api db

ssh :
	docker exec -it railsapi-nuxt-app-api-1 /bin/sh

build:
	docker-compose build api --no-cache