build:
	docker-compose build

serve:
	docker-compose up -d

test: down build
	./bin/test.sh

down:
	docker-compose down

ash: down build
	docker-compose run --rm app ash

views: down build
	docker-compose run --rm app bundle exec ruby main.rb ./data/webserver.log

