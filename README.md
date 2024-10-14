# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

scp -r mindcom@10.0.20.178:/home/mindcom/RUBY_NEW/apps /home/avinash/DOCKER/SMS/RUBY

# ABOUT DOCKER:

---

docker build -t ruby_334 .

docker ps -a

## start & stop the Docker

docker start ruby_334
docker stop ruby_334

## Check Logs:

docker-compose logs app

<!-- docker-compose exec app rails db:migrate:up VERSION=20191121101225 -->

## killing PID:

rm -rf server.pid

## open console:

docker exec -it ruby_334 rails c

## Run comments:

docker exec -it ruby_334 bash

---

If you’re using Docker, ensure that your Docker container is not running multiple instances of the Rails server. You might need to restart your Docker container:

## Build container:

docker-compose up -d --build

## up and down docker:

docker-compose up

docker-compose down

## Clear all precompiled assets:

rake assets:clobber

## If changes happen in assets files then you need to run:

rake assets:precompile

## Auto Detecting the syntax or any issues in ruby:

rubocop

Auto Correcting syntax's commands:

rubocop --auto-correct
rubocop --autocorrect

rubocop -A

Clear bundle:
bundle clean --force
bundle install

Change the syntax in migration:

[avinash@avinash RUBY_NEW]$ chmod +x update_migrations.rb
[avinash@avinash RUBY_NEW]$ ruby update_migrations.rb

Try running your application in interactive mode with:

From the shell, start the Rails server manually:

bundle exec rails server -b 0.0.0.0 -p 3000

Please follow below instruction to work with Docker for new Ruby application

To start docker

$ docker-compose run --rm --service-ports --name ruby_334 app bash

## To start the rails with console (inside the Docker)

rails s -b 0.0.0.0 -p 3000

Note: Container will be dropped as soon as the Docker stop
