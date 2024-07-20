# php-docker-quickstart
A starting project works with PhpStorm for using Docker for PHP for 
development

## Quick start

This project is just a template for a PHP project using Docker. 
It is meant to be a starting point for a PHP project using Docker.
You should replace this readme and code with your own.
You should fork this project and make it your own.

Start by cloning this repository to your local machine.

Make sure you have Docker and Docker Compose installed.

## To start the PHP dev server

From the directory root of the project run `docker compose up` to 
start the PHP server.

Then open your browser to [http://localhost:8088](http://localhost:8088/).

To remove the Docker containers, from the Docker CLI windows press 
[Control]-C and then run `docker compose down`.

## To access the Database

If you have not done so already, start the Docker containers by running
`docker compose up`.

By default, PhpMyAdmin is available at 
[http://localhost:7088](http://localhost:7088/).

To access the database from outside the Docker container, you can use
a database client like MySQL Workbench or DBeaver.  
Use the following connection information:

- Host: `localhost`
- Port: `5000`
- Username: `root`
- Password: `password`
- Database: `app`

## To build a production image

To build a production image, run 
`docker compose docker-compose.yml -f docker-compose.prod.yml up --build`.

## To publish the production image

To publish the production image to Docker Hub, run 
`docker compose -f docker-compose.yml -f docker-compose.prod.yml push`.
