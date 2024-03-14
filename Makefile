install:
		sh bin/install.sh

ps:
		docker-compose ps

up:
		docker-compose up -d

fix:
		docker-compose exec php sh -c 'vendor/bin/php-cs-fixer fix src/'

bash:
		docker-compose exec php bash

stop:
		docker-compose stop

deploy:
		sh bin/deploy.sh

restart: stop up

clean:
		rm -rf data vendor
		docker-compose rm --stop --force
		docker volume prune -f || true
		docker network prune -f || true

build-dev:
	    docker-compose exec php chown -R www-data: var/
		docker-compose exec php sh -c 'composer install'
		docker-compose exec php sh -c 'bin/console assets:install public'
		docker-compose exec php sh -c 'bin/console doctrine:schema:update --force'
		docker-compose exec php sh -c 'bin/console lexik:translations:import'
		docker-compose exec php sh -c 'bin/console cache:clear'
		docker-compose exec php chown -R www-data: .
		cd app/integration && yarn install && yarn run build

cache:
		docker-compose exec php sh -c 'bin/console cache:clear'
